create or replace package body com_fos_progress_bar
as

-- =============================================================================
--
--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)
--
--  This plug-in provides you with a highly customisable Progress Bar item.
--
--  License: MIT
--
--  GitHub: https://github.com/foex-open-source/fos-progress-bar
--
-- =============================================================================
G_IN_ERROR_HANDLING_CALLBACK   boolean := false;

--------------------------------------------------------------------------------
-- private function to include the apex error handling function, if one is
-- defined on application or page level
--------------------------------------------------------------------------------
function error_function_callback
  ( p_error in apex_error.t_error
  )  return apex_error.t_error_result
is
    c_cr constant varchar2(1) := chr(10);

    l_error_handling_function apex_application_pages.error_handling_function%type;
    l_statement               varchar2(32767);
    l_result                  apex_error.t_error_result;

    procedure log_value
      ( p_attribute_name in varchar2
      , p_old_value      in varchar2
      , p_new_value      in varchar2
      )
    is
    begin
        if   p_old_value <> p_new_value
          or (p_old_value is not null and p_new_value is null)
          or (p_old_value is null     and p_new_value is not null)
        then
            apex_debug.info('%s: %s', p_attribute_name, p_new_value);
        end if;
    end log_value;

begin
    if not g_in_error_handling_callback
    then
        g_in_error_handling_callback := true;

        begin
            select /*+ result_cache */
                   coalesce(p.error_handling_function, f.error_handling_function)
              into l_error_handling_function
              from apex_applications f,
                   apex_application_pages p
             where f.application_id     = apex_application.g_flow_id
               and p.application_id (+) = f.application_id
               and p.page_id        (+) = apex_application.g_flow_step_id;
        exception when no_data_found then
            null;
        end;
    end if;

    if l_error_handling_function is not null
    then
        l_statement := 'declare'||c_cr||
                           'l_error apex_error.t_error;'||c_cr||
                       'begin'||c_cr||
                           'l_error := apex_error.g_error;'||c_cr||
                           'apex_error.g_error_result := '||l_error_handling_function||' ('||c_cr||
                               'p_error => l_error );'||c_cr||
                       'end;';

        apex_error.g_error := p_error;

        begin
            apex_exec.execute_plsql(l_statement);
        exception when others then
            apex_debug.error('error in error handler: %s', sqlerrm);
            apex_debug.error('backtrace: %s', dbms_utility.format_error_backtrace);
        end;

        l_result := apex_error.g_error_result;

        if l_result.message is null
        then
            l_result.message          := nvl(l_result.message,          p_error.message);
            l_result.additional_info  := nvl(l_result.additional_info,  p_error.additional_info);
            l_result.display_location := nvl(l_result.display_location, p_error.display_location);
            l_result.page_item_name   := nvl(l_result.page_item_name,   p_error.page_item_name);
            l_result.column_alias     := nvl(l_result.column_alias,     p_error.column_alias);
        end if;
    else
        l_result.message          := p_error.message;
        l_result.additional_info  := p_error.additional_info;
        l_result.display_location := p_error.display_location;
        l_result.page_item_name   := p_error.page_item_name;
        l_result.column_alias     := p_error.column_alias;
    end if;

    if l_result.message = l_result.additional_info
    then
        l_result.additional_info := null;
    end if;

    g_in_error_handling_callback := false;

    return l_result;

exception
    when others then
        l_result.message             := 'custom apex error handling function failed !!';
        l_result.additional_info     := null;
        l_result.display_location    := apex_error.c_on_error_page;
        l_result.page_item_name      := null;
        l_result.column_alias        := null;
        g_in_error_handling_callback := false;

        return l_result;
end error_function_callback;

procedure render
  ( p_item   in            apex_plugin.t_item
  , p_plugin in            apex_plugin.t_plugin
  , p_param  in            apex_plugin.t_item_render_param
  , p_result in out nocopy apex_plugin.t_item_render_result
  )
as
    -- native attributes
    l_name                          p_item.name%type                := apex_escape.html(p_item.name);
    l_value                         p_param.value%type              := apex_escape.html(p_param.value);
    l_classes                       p_item.element_css_classes%type := p_item.element_css_classes;

    l_ajax_id                       varchar2(1000)                  := apex_plugin.get_ajax_identifier;

    l_value_arr                     apex_t_varchar2;
    l_pct_val                       varchar2(100);
    l_msg_val                       varchar2(100);

    -- width and height
    l_width_esc                     p_item.element_width%type       := p_item.element_width;
    l_height                        p_item.element_height%type      := p_item.element_height;

    -- init js
    l_init_js_fn                    varchar2(32767)                 := nvl(apex_plugin_util.replace_substitutions(p_item.init_javascript_code), 'undefined');

    -- attributes
    l_default_message               p_plugin.attribute_01%type      := apex_escape.html(p_plugin.attribute_01);
    l_shape                         p_item.attribute_01%type        := p_item.attribute_01;
    l_custom_shape                  p_item.attribute_02%type        := p_item.attribute_02;
    l_style                         p_item.attribute_03%type        := p_item.attribute_03;
    l_color                         p_item.attribute_04%type        := p_item.attribute_04;
    l_trail_color                   p_item.attribute_05%type        := p_item.attribute_05;
    l_end_color                     p_item.attribute_06%type        := p_item.attribute_06;
    l_animation                     p_item.attribute_07%type        := p_item.attribute_07;
    l_duration                      p_item.attribute_08%type        := p_item.attribute_08;
    l_show_pct                      p_item.attribute_09%type        := p_item.attribute_09;
    l_show_msg                      p_item.attribute_10%type        := p_item.attribute_10;
    l_options                       p_item.attribute_11%type        := p_item.attribute_11;
    l_refresh_interval              p_item.attribute_12%type        := p_item.attribute_12;
    l_repetitions                   p_item.attribute_13%type        := p_item.attribute_13;
    l_num_of_reps                   p_item.attribute_14%type        := p_item.attribute_14;
    l_items_to_submit               p_item.attribute_15%type        := apex_plugin_util.page_item_names_to_jquery(p_item.attribute_15);

    -- local variables
    FOS_PRB_CLS                     constant varchar2(100)          := 'fos-prb-container';
    FOS_PRB_WRAPPER                 constant varchar2(100)          := 'fos-prb-wrapper' ;
    FOS_PRB_MSG_CLS                 constant varchar2(100)          := 'fos-prb-msg';

    l_msg_markup                    constant varchar2(1000)         := '<span class="'|| FOS_PRB_MSG_CLS ||'"></span>';
    l_add_timer                     boolean                         := instr(l_options, 'add-timer')        > 0;
    l_queue_animations              boolean                         := instr(l_options, 'queue-animations') > 0;

begin

    --debug
    if apex_application.g_debug
    then
        apex_plugin_util.debug_item_render
          ( p_plugin => p_plugin
          , p_item   => p_item
          , p_param  => p_param
          );
    end if;

    -- get the values
    if instr(l_value,':') > 0
    then
        l_value_arr := apex_string.split(l_value,':');
        l_pct_val   := l_value_arr(1);
        l_msg_val   := l_value_arr(2);
    else
        l_pct_val   := l_value;
    end if;

    -- create the markup

    sys.htp.p('<div class="'|| FOS_PRB_CLS ||' '|| l_classes || '" ' || p_item.element_attributes ||'>');                                                   -- container open
    sys.htp.p('    <input id="'|| l_name ||'" type="hidden" name="'|| l_name ||'" value="'|| l_value ||'"></input>');   -- input element
    sys.htp.p('    <div class="'||FOS_PRB_WRAPPER||' fos-prb-'|| l_shape ||'" id="'|| l_name||'_WRAPPER">');            -- wrapper
    if l_custom_shape is not null
    then
        sys.htp.p(replace(replace(l_custom_shape, '#TRAIL_COLOR#', l_trail_color), '#COLOR#', l_color));
    end if;

    sys.htp.p('    </div>');                                                                                            -- wrapper close
    sys.htp.p('</div>');                                                                                                -- container close


    apex_json.initialize_clob_output;
    apex_json.open_object;
    apex_json.write('ajaxId'           , l_ajax_id          );
    apex_json.write('name'             , l_name             );
    apex_json.write('pctVal'           , l_pct_val          );
    apex_json.write('msgVal'           , l_msg_val          );
    apex_json.write('shape'            , l_shape            );
    apex_json.write('style'            , l_style            );
    apex_json.write('color'            , l_color            );
    apex_json.write('endColor'         , l_end_color        );
    apex_json.write('trailColor'       , l_trail_color      );
    apex_json.write('animation'        , l_animation        );
    apex_json.write('duration'         , l_duration         );
    apex_json.write('showPct'          , l_show_pct         );
    apex_json.write('showMsg'          , l_show_msg         );
    apex_json.write('msg'              , l_default_message  );
    apex_json.write('customShape'      , l_custom_shape     );
    apex_json.write('addTimer'         , l_add_timer        );
    apex_json.write('refreshInterval'  , l_refresh_interval );
    apex_json.write('repetitions'      , l_repetitions      );
    apex_json.write('numOfReps'        , l_num_of_reps      );
    apex_json.write('itemsToSubmit'    , l_items_to_submit  );
    apex_json.write('queueAnimations'  , l_queue_animations );
    apex_json.close_object;

    apex_javascript.add_onload_code('FOS.item.progressBar.init('|| apex_json.get_clob_output  ||', '|| l_init_js_fn ||')');

    apex_json.free_output;

end render;

procedure ajax
  ( p_item   in            apex_plugin.t_item
  , p_plugin in            apex_plugin.t_plugin
  , p_param  in            apex_plugin.t_item_ajax_param
  , p_result in out nocopy apex_plugin.t_item_ajax_result
  )
as
    -- error handling
    l_apex_error                    apex_error.t_error;
    l_result                        apex_error.t_error_result;
    l_message                       varchar2(32000);

    l_name                          p_item.name%type                := apex_escape.html(p_item.name);
    l_advanced_setting              p_item.attribute_10%type        := p_item.attribute_10;
    l_page_item_to_submit           p_item.attribute_11%type        := p_item.attribute_11;
    l_context                       apex_exec.t_context;

    l_source_type                   varchar2(1000);
    l_source                        varchar2(32000);

    l_value_arr                     apex_t_varchar2;
    l_value                         varchar2(1000);
    l_msg_value                     varchar2(1000);
    l_pct_value                     varchar2(1000);

begin

    --debug
    if apex_application.g_debug
    then
        apex_plugin_util.debug_item
          ( p_plugin => p_plugin
          , p_item   => p_item
          );
    end if;

    -- get the page source
    select item_source_type
         , item_source
      into l_source_type
         , l_source
      from apex_application_page_items
     where application_id = :APP_ID
       and page_id = :APP_PAGE_ID
       and item_name = l_name
    ;

    if instr(l_source_type, 'SQL Query') > 0
    then
        l_context := apex_exec.open_query_context
            ( p_location  => apex_exec.c_location_local_db
            , p_sql_query => l_source
            );

        while apex_exec.next_row(l_context)
        loop
            l_value := apex_exec.get_varchar2(l_context,1);
        end loop;

        apex_exec.close(l_context);
    elsif instr(l_source_type,'PL/SQL Expression') > 0 or l_source_type = 'Expression'
    then
        l_value := apex_plugin_util.get_plsql_expression_result
            ( p_plsql_expression => l_source
            );
    elsif instr(l_source_type, 'PL/SQL Function') > 0 or l_source_type = 'Function'
    then
        l_value := apex_plugin_util.get_plsql_function_result
            ( p_plsql_function => l_source
            );
    -- @todo: support SQL Expressions +20.1
    end if;

    -- get the values
    if instr(l_value,':') > 0
    then
        l_value_arr   := apex_string.split(l_value,':');
        l_pct_value   := l_value_arr(1);
        l_msg_value   := l_value_arr(2);
    else
        l_pct_value   := l_value;
    end if;

    apex_json.open_object;
    apex_json.write('success'  , true        );
    apex_json.write('value'    , l_pct_value );
    apex_json.write('msg'      , l_msg_value , true);
    apex_json.close_object;

exception
    when others then
        apex_exec.close(l_context);
        l_message := coalesce(apex_application.g_x01, sqlerrm);
        l_message := replace(l_message, '#SQLCODE#', apex_escape.html_attribute(sqlcode));
        l_message := replace(l_message, '#SQLERRM#', apex_escape.html_attribute(sqlerrm));
        l_message := replace(l_message, '#SQLERRM_TEXT#', apex_escape.html_attribute(substr(sqlerrm, instr(sqlerrm, ':')+1)));

        apex_json.initialize_output;
        l_apex_error.message             := l_message;
        l_apex_error.ora_sqlcode         := sqlcode;
        l_apex_error.ora_sqlerrm         := sqlerrm;
        l_apex_error.error_backtrace     := dbms_utility.format_error_backtrace;

        l_result := error_function_callback(l_apex_error);

        apex_json.open_object;
        apex_json.write('status' , 'error');
        apex_json.write('success', false);
        apex_json.write('errMsg' , SQLERRM);

        apex_json.close_object;
        sys.htp.p(apex_json.get_clob_output);
        apex_json.free_output;

end ajax;

end;
/


