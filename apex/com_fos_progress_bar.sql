prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.10.04'
,p_release=>'19.2.0.00.18'
,p_default_workspace_id=>1620873114056663
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'FOS_MASTER_WS'
);
end;
/

prompt APPLICATION 102 - FOS Dev - Plugin Master
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev - Plugin Master
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 61118001090994374
--     PLUGIN: 134108205512926532
--     PLUGIN: 1039471776506160903
--     PLUGIN: 547902228942303344
--     PLUGIN: 217651153971039957
--     PLUGIN: 412155278231616931
--     PLUGIN: 1389837954374630576
--     PLUGIN: 461352325906078083
--     PLUGIN: 13235263798301758
--     PLUGIN: 216426771609128043
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 106296184223956059
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 183507938916453268
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--     PLUGIN: 98648032013264649
--     PLUGIN: 455014954654760331
--     PLUGIN: 98504124924145200
--     PLUGIN: 212503470416800524
--   Manifest End
--   Version:         19.2.0.00.18
--   Instance ID:     250144500186934
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/com_fos_progress_bar
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(217651153971039957)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.FOS.PROGRESS_BAR'
,p_display_name=>'FOS - Progress Bar'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#js/script.js',
'#PLUGIN_FILES#progressbarjs/js/progressbar.min.js'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#css/style.css',
''))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- =============================================================================',
'--',
'--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)',
'--',
'--  This plug-in provides you with a highly customisable Progress Bar item.',
'--',
'--  License: MIT',
'--',
'--  GitHub: https://github.com/foex-open-source/fos-progress-bar',
'--',
'-- =============================================================================',
'G_IN_ERROR_HANDLING_CALLBACK   boolean := false;',
'',
'--------------------------------------------------------------------------------',
'-- private function to include the apex error handling function, if one is',
'-- defined on application or page level',
'--------------------------------------------------------------------------------',
'function error_function_callback',
'  ( p_error in apex_error.t_error',
'  )  return apex_error.t_error_result',
'is',
'    c_cr constant varchar2(1) := chr(10);',
'',
'    l_error_handling_function apex_application_pages.error_handling_function%type;',
'    l_statement               varchar2(32767);',
'    l_result                  apex_error.t_error_result;',
'',
'    procedure log_value',
'      ( p_attribute_name in varchar2',
'      , p_old_value      in varchar2',
'      , p_new_value      in varchar2 ',
'      )',
'    is',
'    begin',
'        if   p_old_value <> p_new_value',
'          or (p_old_value is not null and p_new_value is null)',
'          or (p_old_value is null     and p_new_value is not null)',
'        then',
'            apex_debug.info(''%s: %s'', p_attribute_name, p_new_value);',
'        end if;',
'    end log_value;',
'',
'begin',
'    if not g_in_error_handling_callback ',
'    then',
'        g_in_error_handling_callback := true;',
'',
'        begin',
'            select /*+ result_cache */',
'                   coalesce(p.error_handling_function, f.error_handling_function)',
'              into l_error_handling_function',
'              from apex_applications f,',
'                   apex_application_pages p',
'             where f.application_id     = apex_application.g_flow_id',
'               and p.application_id (+) = f.application_id',
'               and p.page_id        (+) = apex_application.g_flow_step_id;',
'        exception when no_data_found then',
'            null;',
'        end;',
'    end if;',
'',
'    if l_error_handling_function is not null',
'    then',
'        l_statement := ''declare''||c_cr||',
'                           ''l_error apex_error.t_error;''||c_cr||',
'                       ''begin''||c_cr||',
'                           ''l_error := apex_error.g_error;''||c_cr||',
'                           ''apex_error.g_error_result := ''||l_error_handling_function||'' (''||c_cr||',
'                               ''p_error => l_error );''||c_cr||',
'                       ''end;'';',
'',
'        apex_error.g_error := p_error;',
'',
'        begin',
'            apex_exec.execute_plsql(l_statement);',
'        exception when others then',
'            apex_debug.error(''error in error handler: %s'', sqlerrm);',
'            apex_debug.error(''backtrace: %s'', dbms_utility.format_error_backtrace);',
'        end;',
'',
'        l_result := apex_error.g_error_result;',
'',
'        if l_result.message is null',
'        then',
'            l_result.message          := nvl(l_result.message,          p_error.message);',
'            l_result.additional_info  := nvl(l_result.additional_info,  p_error.additional_info);',
'            l_result.display_location := nvl(l_result.display_location, p_error.display_location);',
'            l_result.page_item_name   := nvl(l_result.page_item_name,   p_error.page_item_name);',
'            l_result.column_alias     := nvl(l_result.column_alias,     p_error.column_alias);',
'        end if;',
'    else',
'        l_result.message          := p_error.message;',
'        l_result.additional_info  := p_error.additional_info;',
'        l_result.display_location := p_error.display_location;',
'        l_result.page_item_name   := p_error.page_item_name;',
'        l_result.column_alias     := p_error.column_alias;',
'    end if;',
'',
'    if l_result.message = l_result.additional_info',
'    then',
'        l_result.additional_info := null;',
'    end if;',
'',
'    g_in_error_handling_callback := false;',
'',
'    return l_result;',
'',
'exception',
'    when others then',
'        l_result.message             := ''custom apex error handling function failed !!'';',
'        l_result.additional_info     := null;',
'        l_result.display_location    := apex_error.c_on_error_page;',
'        l_result.page_item_name      := null;',
'        l_result.column_alias        := null;',
'        g_in_error_handling_callback := false;',
'        ',
'        return l_result;',
'end error_function_callback;',
'',
'procedure render',
'  ( p_item   in            apex_plugin.t_item',
'  , p_plugin in            apex_plugin.t_plugin',
'  , p_param  in            apex_plugin.t_item_render_param',
'  , p_result in out nocopy apex_plugin.t_item_render_result ',
'  )',
'as',
'    -- native attributes',
'    l_name                          p_item.name%type                := apex_escape.html(p_item.name);',
'    l_value                         p_param.value%type              := apex_escape.html(p_param.value);',
'    l_classes                       p_item.element_css_classes%type := p_item.element_css_classes;',
'    ',
'    l_ajax_id                       varchar2(1000)                  := apex_plugin.get_ajax_identifier;',
'    ',
'    l_value_arr                     apex_t_varchar2;',
'    l_pct_val                       varchar2(100);',
'    l_msg_val                       varchar2(100);',
'     ',
'    -- width and height ',
'    l_width_esc                     p_item.element_width%type       := p_item.element_width;',
'    l_height                        p_item.element_height%type      := p_item.element_height;',
'    ',
'    -- init js',
'    l_init_js_fn                    varchar2(32767)                 := nvl(apex_plugin_util.replace_substitutions(p_item.init_javascript_code), ''undefined'');',
'',
'    -- attributes',
'    l_default_message               p_plugin.attribute_01%type      := apex_escape.html(p_plugin.attribute_01);',
'    l_shape                         p_item.attribute_01%type        := p_item.attribute_01;',
'    l_custom_shape                  p_item.attribute_02%type        := p_item.attribute_02;',
'    l_style                         p_item.attribute_03%type        := p_item.attribute_03;',
'    l_color                         p_item.attribute_04%type        := p_item.attribute_04;',
'    l_trail_color                   p_item.attribute_05%type        := p_item.attribute_05;',
'    l_end_color                     p_item.attribute_06%type        := p_item.attribute_06;',
'    l_animation                     p_item.attribute_07%type        := p_item.attribute_07;',
'    l_duration                      p_item.attribute_08%type        := p_item.attribute_08;',
'    l_show_pct                      p_item.attribute_09%type        := p_item.attribute_09;',
'    l_show_msg                      p_item.attribute_10%type        := p_item.attribute_10;',
'    l_options                       p_item.attribute_11%type        := p_item.attribute_11;',
'    l_refresh_interval              p_item.attribute_12%type        := p_item.attribute_12;',
'    l_repetitions                   p_item.attribute_13%type        := p_item.attribute_13;',
'    l_num_of_reps                   p_item.attribute_14%type        := p_item.attribute_14;',
'    l_items_to_submit               p_item.attribute_15%type        := apex_plugin_util.page_item_names_to_jquery(p_item.attribute_15);',
'    ',
'    -- local variables',
'    FOS_PRB_CLS                     constant varchar2(100)          := ''fos-prb-container'';',
'    FOS_PRB_WRAPPER                 constant varchar2(100)          := ''fos-prb-wrapper'' ;',
'    FOS_PRB_MSG_CLS                 constant varchar2(100)          := ''fos-prb-msg'';',
'    ',
'    l_msg_markup                    constant varchar2(1000)         := ''<span class="''|| FOS_PRB_MSG_CLS ||''"></span>'';',
'    l_add_timer                     boolean                         := instr(l_options, ''add-timer'')        > 0;',
'    l_queue_animations              boolean                         := instr(l_options, ''queue-animations'') > 0;',
'    ',
'begin',
'',
'    --debug',
'    if apex_application.g_debug ',
'    then',
'        apex_plugin_util.debug_item_render',
'          ( p_plugin => p_plugin',
'          , p_item   => p_item',
'          , p_param  => p_param',
'          );',
'    end if;',
'    ',
'    -- get the values',
'    if instr(l_value,'':'') > 0',
'    then',
'        l_value_arr := apex_string.split(l_value,'':'');',
'        l_pct_val   := l_value_arr(1);',
'        l_msg_val   := l_value_arr(2);',
'    else ',
'        l_pct_val   := l_value;',
'    end if;',
'',
'    -- create the markup',
'',
'    sys.htp.p(''<div class="''|| FOS_PRB_CLS ||'' ''|| l_classes || ''" '' || p_item.element_attributes ||''>'');                                                   -- container open',
'    sys.htp.p(''    <input id="''|| l_name ||''" type="hidden" name="''|| l_name ||''" value="''|| l_value ||''"></input>'');   -- input element',
'    sys.htp.p(''    <div class="''||FOS_PRB_WRAPPER||'' fos-prb-''|| l_shape ||''" id="''|| l_name||''_WRAPPER">'');            -- wrapper',
'    if l_custom_shape is not null',
'    then',
'        sys.htp.p(replace(replace(l_custom_shape, ''#TRAIL_COLOR#'', l_trail_color), ''#COLOR#'', l_color));',
'    end if;',
'    ',
'    sys.htp.p(''    </div>'');                                                                                            -- wrapper close',
'    sys.htp.p(''</div>'');                                                                                                -- container close',
'    ',
'    ',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    apex_json.write(''ajaxId''           , l_ajax_id          );',
'    apex_json.write(''name''             , l_name             );',
'    apex_json.write(''pctVal''           , l_pct_val          );',
'    apex_json.write(''msgVal''           , l_msg_val          );',
'    apex_json.write(''shape''            , l_shape            );',
'    apex_json.write(''style''            , l_style            );',
'    apex_json.write(''color''            , l_color            );',
'    apex_json.write(''endColor''         , l_end_color        );',
'    apex_json.write(''trailColor''       , l_trail_color      );',
'    apex_json.write(''animation''        , l_animation        );',
'    apex_json.write(''duration''         , l_duration         );',
'    apex_json.write(''showPct''          , l_show_pct         );',
'    apex_json.write(''showMsg''          , l_show_msg         );',
'    apex_json.write(''msg''              , l_default_message  );',
'    apex_json.write(''customShape''      , l_custom_shape     );',
'    apex_json.write(''addTimer''         , l_add_timer        );',
'    apex_json.write(''refreshInterval''  , l_refresh_interval );',
'    apex_json.write(''repetitions''      , l_repetitions      );',
'    apex_json.write(''numOfReps''        , l_num_of_reps      );    ',
'    apex_json.write(''itemsToSubmit''    , l_items_to_submit  );',
'    apex_json.write(''queueAnimations''  , l_queue_animations );',
'    apex_json.close_object;',
'    ',
'    apex_javascript.add_onload_code(''FOS.item.progressBar.init(''|| apex_json.get_clob_output  ||'', ''|| l_init_js_fn ||'')'');',
'    ',
'    apex_json.free_output;',
'',
'end render;',
'',
'procedure ajax',
'  ( p_item   in            apex_plugin.t_item',
'  , p_plugin in            apex_plugin.t_plugin',
'  , p_param  in            apex_plugin.t_item_ajax_param',
'  , p_result in out nocopy apex_plugin.t_item_ajax_result ',
'  )',
'as',
'    -- error handling',
'    l_apex_error                    apex_error.t_error;',
'    l_result                        apex_error.t_error_result;',
'    l_message                       varchar2(32000);',
'',
'    l_name                          p_item.name%type                := apex_escape.html(p_item.name);',
'    l_advanced_setting              p_item.attribute_10%type        := p_item.attribute_10;',
'    l_page_item_to_submit           p_item.attribute_11%type        := p_item.attribute_11;',
'    l_context                       apex_exec.t_context;',
'    ',
'    l_source_type                   varchar2(1000);',
'    l_source                        varchar2(32000);',
'    ',
'    l_value_arr                     apex_t_varchar2;',
'    l_value                         varchar2(1000);',
'    l_msg_value                     varchar2(1000);',
'    l_pct_value                     varchar2(1000);',
'    ',
'begin',
'',
'    --debug',
'    if apex_application.g_debug ',
'    then',
'        apex_plugin_util.debug_item',
'          ( p_plugin => p_plugin',
'          , p_item   => p_item',
'          );',
'    end if;',
'    ',
'    -- get the page source',
'    select item_source_type',
'         , item_source',
'      into l_source_type',
'         , l_source',
'      from apex_application_page_items',
'     where application_id = :APP_ID',
'       and page_id = :APP_PAGE_ID',
'       and item_name = l_name',
'    ;',
'    ',
'    if instr(l_source_type, ''SQL Query'') > 0',
'    then',
'        l_context := apex_exec.open_query_context',
'            ( p_location  => apex_exec.c_location_local_db',
'            , p_sql_query => l_source',
'            );',
'',
'        while apex_exec.next_row(l_context)',
'        loop',
'            l_value := apex_exec.get_varchar2(l_context,1);',
'        end loop;',
'',
'        apex_exec.close(l_context);',
'    elsif instr(l_source_type,''PL/SQL Expression'') > 0 or l_source_type = ''Expression''',
'    then',
'        l_value := apex_plugin_util.get_plsql_expression_result',
'            ( p_plsql_expression => l_source',
'            );',
'    elsif instr(l_source_type, ''PL/SQL Function'') > 0 or l_source_type = ''Function''',
'    then',
'        l_value := apex_plugin_util.get_plsql_function_result',
'            ( p_plsql_function => l_source',
'            );',
'    -- @todo: support SQL Expressions +20.1',
'    end if;',
'    ',
'    -- get the values',
'    if instr(l_value,'':'') > 0',
'    then',
'        l_value_arr   := apex_string.split(l_value,'':'');',
'        l_pct_value   := l_value_arr(1);',
'        l_msg_value   := l_value_arr(2);',
'    else ',
'        l_pct_value   := l_value;',
'    end if;',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success''  , true        );',
'    apex_json.write(''value''    , l_pct_value );',
'    apex_json.write(''msg''      , l_msg_value , true);',
'    apex_json.close_object;',
'    ',
'exception',
'    when others then',
'        apex_exec.close(l_context);',
'        l_message := coalesce(apex_application.g_x01, sqlerrm);',
'        l_message := replace(l_message, ''#SQLCODE#'', apex_escape.html_attribute(sqlcode));',
'        l_message := replace(l_message, ''#SQLERRM#'', apex_escape.html_attribute(sqlerrm));',
'        l_message := replace(l_message, ''#SQLERRM_TEXT#'', apex_escape.html_attribute(substr(sqlerrm, instr(sqlerrm, '':'')+1)));',
'',
'        apex_json.initialize_output;',
'        l_apex_error.message             := l_message;',
'        l_apex_error.ora_sqlcode         := sqlcode;',
'        l_apex_error.ora_sqlerrm         := sqlerrm;',
'        l_apex_error.error_backtrace     := dbms_utility.format_error_backtrace;',
'        ',
'        l_result := error_function_callback(l_apex_error);',
'',
'        apex_json.open_object;',
'        apex_json.write(''status'' , ''error'');',
'        apex_json.write(''success'', false);',
'        apex_json.write(''errMsg'' , SQLERRM);',
'        ',
'        apex_json.close_object;',
'        sys.htp.p(apex_json.get_clob_output);',
'        apex_json.free_output;',
'    ',
'end ajax;'))
,p_api_version=>2
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SOURCE:ELEMENT:INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The <strong>FOS - Progress Bar</strong> item plug-in offers a visually impressive and flexible way to display progress within your APEX applications. You can customize the display type, colors, animations, messages, automated refreshing, and more.'
||'...</p>',
'<p>The plug-in is built on top of the open source <a href="https://kimmobrunfeldt.github.io/progressbar.js/" target="_blank">ProgressBar.js</a> javascript library, which makes it possible to implement responsive and slick progress bars with animated '
||'SVG paths.</p>'))
,p_version_identifier=>'21.2.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Settings for the FOS browser extension',
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>1847
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(229046342983223532)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Default Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Loading...'
,p_is_translatable=>true
,p_help_text=>'<p>Enter the default text you would like to display when the progress bar message attribute is enabled but no value is provided.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217651781851156007)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Shape'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'line'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select the shape of the progress bar.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217652088991162397)
,p_plugin_attribute_id=>wwv_flow_api.id(217651781851156007)
,p_display_sequence=>10
,p_display_value=>'Line'
,p_return_value=>'line'
,p_help_text=>'<p>The default progress bar.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217652410682171391)
,p_plugin_attribute_id=>wwv_flow_api.id(217651781851156007)
,p_display_sequence=>20
,p_display_value=>'Circle'
,p_return_value=>'circle'
,p_help_text=>'<p>A round shaped progress bar.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217653664232205581)
,p_plugin_attribute_id=>wwv_flow_api.id(217651781851156007)
,p_display_sequence=>30
,p_display_value=>'Semi-circle'
,p_return_value=>'semi-circle'
,p_help_text=>'<p>A semi-circle shaped progress bar.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(219286915981085665)
,p_plugin_attribute_id=>wwv_flow_api.id(217651781851156007)
,p_display_sequence=>40
,p_display_value=>'Custom'
,p_return_value=>'custom'
,p_help_text=>'<p>Custom shape, based on the provided SVG.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(219295343477128937)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Custom SVG Path'
,p_attribute_type=>'HTML'
,p_is_required=>false
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(217651781851156007)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'custom'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre><svg xmlns="http://www.w3.org/2000/svg" version="1.1" x="0px" y="0px" viewBox="0 0 100 100">',
'    <path fill-opacity="0" stroke-width="1" stroke="#TRAIL_COLOR#" d="M81.495,13.923c-11.368-5.261-26.234-0.311-31.489,11.032C44.74,13.612,29.879,8.657,18.511,13.923  C6.402,19.539,0.613,33.883,10.175,50.804c6.792,12.04,18.826,21.111,39.831,37.379c20'
||'.993-16.268,33.033-25.344,39.819-37.379  C99.387,33.883,93.598,19.539,81.495,13.923z"/>',
'    <path id="heart-path" fill-opacity="0" stroke-width="3" stroke="#COLOR#" d="M81.495,13.923c-11.368-5.261-26.234-0.311-31.489,11.032C44.74,13.612,29.879,8.657,18.511,13.923  C6.402,19.539,0.613,33.883,10.175,50.804c6.792,12.04,18.826,21.111,39.831'
||',37.379c20.993-16.268,33.033-25.344,39.819-37.379  C99.387,33.883,93.598,19.539,81.495,13.923z"/>',
'</svg>',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Provide your custom SVG element, which must contain 1 or 2 <i>"path"</i> element(s). You can use the substitutions #COLOR# and #TRAIL_COLOR# to substitute the chosen plug-in color values.</p>',
'<p><strong>Note:</strong> the plug-in will assign an <i>"id"</i> to the <i>"path"</i> element, so any provided value will be overwritten.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217654388547480346)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'solid'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The color style of the progress bar.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217655077836787298)
,p_plugin_attribute_id=>wwv_flow_api.id(217654388547480346)
,p_display_sequence=>10
,p_display_value=>'Solid'
,p_return_value=>'solid'
,p_help_text=>'<p>A solid progress bar, with one color.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217655801633796068)
,p_plugin_attribute_id=>wwv_flow_api.id(217654388547480346)
,p_display_sequence=>30
,p_display_value=>'Gradient'
,p_return_value=>'gradient'
,p_help_text=>'<p>The progress bar transitions between two colors.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217656361602803701)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#00A02D'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_help_text=>'<p>The main color of the progress bar.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217733785451457057)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Trail Color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#eee'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_help_text=>'<p>The background color of the progress bar.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217874972415870823)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'End Color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#CC2525'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(217654388547480346)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'gradient'
,p_help_text=>'<p>The end color of the progress bar.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217734337580458483)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Animation'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'ease-in'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The animation of the progress bar.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217735367956467110)
,p_plugin_attribute_id=>wwv_flow_api.id(217734337580458483)
,p_display_sequence=>10
,p_display_value=>'Ease-in'
,p_return_value=>'ease-in'
,p_help_text=>'<p>The animation has a slow start.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217735737897469518)
,p_plugin_attribute_id=>wwv_flow_api.id(217734337580458483)
,p_display_sequence=>20
,p_display_value=>'Ease-out'
,p_return_value=>'ease-out'
,p_help_text=>'<p>The animation has a slow end.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217734939297464148)
,p_plugin_attribute_id=>wwv_flow_api.id(217734337580458483)
,p_display_sequence=>30
,p_display_value=>'Ease-In-Out'
,p_return_value=>'ease-in-out'
,p_help_text=>'<p>The animation has a slow start, then fast, before it ends slow.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217756711309449105)
,p_plugin_attribute_id=>wwv_flow_api.id(217734337580458483)
,p_display_sequence=>40
,p_display_value=>'Linear'
,p_return_value=>'linear'
,p_help_text=>'<p>A linear animation.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217867197678639541)
,p_plugin_attribute_id=>wwv_flow_api.id(217734337580458483)
,p_display_sequence=>50
,p_display_value=>'Bounce'
,p_return_value=>'bounce'
,p_help_text=>'<p>A bounce animation.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217742493435576046)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Duration'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1000'
,p_unit=>'ms'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_help_text=>'<p>The duration of the animation in milliseconds.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217656630733809856)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Show Percentage'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'on-element'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select whether the percentage should be displayed or not.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217656914965812776)
,p_plugin_attribute_id=>wwv_flow_api.id(217656630733809856)
,p_display_sequence=>10
,p_display_value=>'No'
,p_return_value=>'no'
,p_help_text=>'<p>The percentage is hidden.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217657303200818700)
,p_plugin_attribute_id=>wwv_flow_api.id(217656630733809856)
,p_display_sequence=>20
,p_display_value=>'On Element'
,p_return_value=>'on-element'

,p_help_text=>'<p>The percentage is displayed on the progress bar element. (Does not supported with <i>"Shape"</i> set to <i>"Custom"</i>)</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217657764851824670)
,p_plugin_attribute_id=>wwv_flow_api.id(217656630733809856)
,p_display_sequence=>30
,p_display_value=>'Above Element'
,p_return_value=>'above-element'
,p_help_text=>'<p>The percentage is displayed above the element.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217658126471828549)
,p_plugin_attribute_id=>wwv_flow_api.id(217656630733809856)
,p_display_sequence=>40
,p_display_value=>'Below Element'
,p_return_value=>'below-element'
,p_help_text=>'<p>The percentage is displayed below the element.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(217658543534834957)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Show Message'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'on-element'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Set whether a message should be displayed or not.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217658809821836858)
,p_plugin_attribute_id=>wwv_flow_api.id(217658543534834957)
,p_display_sequence=>10
,p_display_value=>'No'
,p_return_value=>'no'
,p_help_text=>'<p>No message is displayed.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217659276458839746)
,p_plugin_attribute_id=>wwv_flow_api.id(217658543534834957)
,p_display_sequence=>20
,p_display_value=>'On Element'
,p_return_value=>'on-element'
,p_help_text=>'<p>The message is displayed on the progress bar element. (It does not supported with <i>"Shape"</i> set to <i>"Custom"</i>.)</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217659670386841930)
,p_plugin_attribute_id=>wwv_flow_api.id(217658543534834957)
,p_display_sequence=>30
,p_display_value=>'Above Element'
,p_return_value=>'above-element'
,p_help_text=>'<p>The message is displayed above the progress bar element.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(217660035174843560)
,p_plugin_attribute_id=>wwv_flow_api.id(217658543534834957)
,p_display_sequence=>40
,p_display_value=>'Below Element'
,p_return_value=>'below-element'
,p_help_text=>'<p>The message is displayed below the progress bar element.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(219374697219465070)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Extra options to control the Progress Bar.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(227979281201872817)
,p_plugin_attribute_id=>wwv_flow_api.id(219374697219465070)
,p_display_sequence=>10
,p_display_value=>'Queue Animations'
,p_return_value=>'queue-animations'
,p_help_text=>'<p>If enabled, the animations will be added to the effect queue, ie. every animation will finish completely, before the next one. Otherwise, the animation will begin immediately</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(219374964784466542)
,p_plugin_attribute_id=>wwv_flow_api.id(219374697219465070)
,p_display_sequence=>20
,p_display_value=>'Add Timer'
,p_return_value=>'add-timer'
,p_help_text=>'<p>Refresh the progress bar within a specified interval.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(218249236521023475)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Interval'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_default_value=>'1000'
,p_unit=>'ms'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(219374697219465070)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'add-timer'
,p_help_text=>'<p>The auto-refresh interval in milliseconds.</p>'
);
end;
/
begin
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(218250359133062834)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Repetitions'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'progress-is-complete'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(219374697219465070)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'add-timer'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Choose the repetition type. It can either be a maximum number of repetitions or indefinitely until progress is complete i.e. 100%</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(218250627430065234)
,p_plugin_attribute_id=>wwv_flow_api.id(218250359133062834)
,p_display_sequence=>10
,p_display_value=>'Until Progress is Complete'
,p_return_value=>'progress-is-complete'
,p_help_text=>'<p>The timer stops when the progress is complete, ie. reaches 100%.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(218251436923096604)
,p_plugin_attribute_id=>wwv_flow_api.id(218250359133062834)
,p_display_sequence=>30
,p_display_value=>'Maximum Number of Repetitions'
,p_return_value=>'number-of-repetitions'
,p_help_text=>'The maximum number of iterations the timer will fire for e.g. 10 if the progress is completed before this number is reached the timer is removed.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(219337360435344140)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Number of Repetitions'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'15'
,p_unit=>'s'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(218250359133062834)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'number-of-repetitions'
,p_help_text=>'<p>Enter the number of iterations you want the timer to fire for e.g. 1.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(218243981428144577)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>150
,p_prompt=>'Page Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(219374697219465070)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'add-timer'
,p_help_text=>'<p>Enter the page items submitted to the server, and therefore, available for use within your SQL or PL/SQL Code.</p>'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(217651377390039959)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
,p_depending_on_has_to_exist=>true
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>function(config){',
'    config.height = ''10px'';',
'    config.strokeWidth = ''10px'';',
'    config.trailWidth = ''5px'';',
'    config.msgColor = ''#ffffff'';',
'    config.autoStartInterval = true;',
'    return config;',
'}',
'</pre>'))
,p_help_text=>'<p>Javascript function which allows you to override any settings.</p>'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(219712874095210867)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_name=>'fos_prb_after_refresh'
,p_display_name=>'FOS - Progress Bar - After Refresh'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(219712455922210867)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_name=>'fos_prb_before_refresh'
,p_display_name=>'FOS - Progress Bar - Before Refresh'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(219723214274301208)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_name=>'fos_prb_interval_over'
,p_display_name=>'FOS - Progress Bar - Interval End'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(219712152732210866)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_name=>'fos_prb_progress_complete'
,p_display_name=>'FOS - Progress Bar - Progress Complete'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C20617065782C24202A2F0A0A77696E646F772E464F53203D2077696E646F772E464F53207C7C207B7D3B0A464F532E6974656D203D20464F532E6974656D207C7C207B7D3B0A0A464F532E6974656D2E70726F6772657373426172';
wwv_flow_api.g_varchar2_table(2) := '203D202866756E6374696F6E202829207B0A20202020636F6E7374204D41585F56414C5545203D203130303B0A20202020636F6E7374204D494E5F56414C5545203D20303B0A20202020636F6E7374204D53475F434C53203D2027666F732D7072622D6D';
wwv_flow_api.g_varchar2_table(3) := '73672D626F78273B0A20202020636F6E7374205052425F434F4E5441494E45525F434C53203D2027666F732D7072622D636F6E7461696E6572273B0A0A20202020636F6E7374204556454E545F434F4D504C455445203D2027666F735F7072625F70726F';
wwv_flow_api.g_varchar2_table(4) := '67726573735F636F6D706C657465273B0A20202020636F6E7374204556454E545F4245464F52455F52454652455348203D2027666F735F7072625F6265666F72655F72656672657368273B0A20202020636F6E7374204556454E545F41465445525F5245';
wwv_flow_api.g_varchar2_table(5) := '4652455348203D2027666F735F7072625F61667465725F72656672657368273B0A20202020636F6E7374204556454E545F494E54455256414C5F4F564552203D2027666F735F7072625F696E74657276616C5F6F766572273B0A0A202020202F2A2A0A20';
wwv_flow_api.g_varchar2_table(6) := '2020202A0A202020202A2040706172616D207B6F626A6563747D20202009636F6E6669672009202020202020202020202020202020202020202009436F6E66696775726174696F6E206F626A65637420636F6E7461696E696E672074686520706C756769';
wwv_flow_api.g_varchar2_table(7) := '6E2073657474696E67730A202020202A2040706172616D207B737472696E677D20202009636F6E6669672E6E616D6520202020202020202020202020202020202009546865206E616D65206F6620746865206974656D0A202020202A2040706172616D20';
wwv_flow_api.g_varchar2_table(8) := '7B737472696E677D20202020202020636F6E6669672E616A61784964202020202020202020202020202020202020204E6563657373617279206964656E74696669657220666F7220414A41582063616C6C732020202020202020202020202020200A2020';
wwv_flow_api.g_varchar2_table(9) := '20202A2040706172616D207B737472696E677D20202020202020636F6E6669672E70637456616C2020202020202020202020202020202020202054686520252076616C7565206F66207468652070726F677265737320626172202020200A202020202A20';
wwv_flow_api.g_varchar2_table(10) := '40706172616D207B737472696E677D20202020202020636F6E6669672E6D736756616C20202020202020202020202020202020202020546865206D65737361676520746F20626520646973706C61796564207769746820746865206974656D202020200A';
wwv_flow_api.g_varchar2_table(11) := '202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E68656967687420202020202020202020202020202020202020486569676874206F6620746865206974656D0A202020202A2040706172616D207B737472696E677D';
wwv_flow_api.g_varchar2_table(12) := '20202020202020636F6E6669672E736861706520202020202020202020202020202020202020205368617065206F66207468652070726F6772657373206261720A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E';
wwv_flow_api.g_varchar2_table(13) := '7374796C652020202020202020202020202020202020202020436F6C6F72207374796C65206F6620746865206974656D2E0A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E636F6C6F7220202020202020202020';
wwv_flow_api.g_varchar2_table(14) := '20202020202020202020546865206D61696E20636F6C6F72206F6620746865206261720A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E656E64436F6C6F7220202020202020202020202020202020204F6E6C79';
wwv_flow_api.g_varchar2_table(15) := '206966207374796C652073657420746F20226772616469656E74223B207468652074617267657420636F6C6F722E0A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E747261696C436F6C6F722020202020202020';
wwv_flow_api.g_varchar2_table(16) := '20202020202020436F6C6F72206F66207468652070726F677265737320747261696C2E0A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E616E696D6174696F6E20202020202020202020202020202020416E696D';
wwv_flow_api.g_varchar2_table(17) := '74696F6E206F6620746865207472616E73696F74696F6E730A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E6475726174696F6E20202020202020202020202020202020204475726174696F6E206F6620746865';
wwv_flow_api.g_varchar2_table(18) := '20616E696D6174696F6E0A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E73686F7750637420202020202020202020202020202020202054686520706F736974696F6E206F662074686520252076616C75652E0A';
wwv_flow_api.g_varchar2_table(19) := '202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E73686F774D736720202020202020202020202020202020202054686520706F736974696F6E206F6620746865206D6573736167652E0A202020202A204070617261';
wwv_flow_api.g_varchar2_table(20) := '6D207B737472696E677D20202020202020636F6E6669672E637573746F6D53686170652020202020202020202020202020535647206F662074686520637573746F6D2073686170652E0A202020202A2040706172616D207B626F6F6C65616E7D20202020';
wwv_flow_api.g_varchar2_table(21) := '2020636F6E6669672E61646454696D65722020202020202020202020202020202020456E61626C65206175746F20726566726573680A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E72656672657368496E7465';
wwv_flow_api.g_varchar2_table(22) := '7276616C20202020202020202020546865207265667265736820696E74657276616C2E0A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E72657065746974696F6E73202020202020202020202020202054686520';
wwv_flow_api.g_varchar2_table(23) := '656E64206F6620746865207265706570746974696F6E732E0A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E6E756D4F6652657073202020202020202020202020202020204D617820616C6C6F77656420726570';
wwv_flow_api.g_varchar2_table(24) := '65746974696F6E732E0A202020202A2040706172616D207B737472696E677D20202020202020636F6E6669672E6974656D73546F5375626D69742020202020202020202020204974656D73207573656420696E2074686520736F75726365207175657279';
wwv_flow_api.g_varchar2_table(25) := '2E0A202020202A2040706172616D207B626F6F6C65616E7D202020202020636F6E6669672E6175746F5374617274496E74657276616C20202020202020205374617274207468652074696D657220696D6D6564696174656C792E0A202020202A20407061';
wwv_flow_api.g_varchar2_table(26) := '72616D207B626F6F6C65616E7D202020202020636F6E6669672E7175657565416E696D6174696F6E73202020202020202020205374617274207468652074696D657220616E696D6174696F6E7320696D6D6564696174656C79206F722061646420746865';
wwv_flow_api.g_varchar2_table(27) := '6D20746F207468652071756575652E0A202020202A2040706172616D207B66756E6374696F6E7D202009696E69744A7320200909090909094F7074696F6E616C20496E697469616C697A6174696F6E204A61766153637269707420436F64652066756E63';
wwv_flow_api.g_varchar2_table(28) := '74696F6E0A202020202A2F0A0A202020206C657420696E6974203D2066756E6374696F6E2028636F6E6669672C20696E69744A5329207B0A20202020202020202F2F2064656661756C742076616C7565730A2020202020202020636F6E6669672E737472';
wwv_flow_api.g_varchar2_table(29) := '6F6B655769647468203D2031303B0A2020202020202020636F6E6669672E747261696C5769647468203D2031303B0A2020202020202020636F6E6669672E6D7367436F6C6F72203D202723303030303030273B0A2020202020202020636F6E6669672E6D';
wwv_flow_api.g_varchar2_table(30) := '7367203D20636F6E6669672E6D7367207C7C20274C6F6164696E672E2E2E273B0A2020202020202020636F6E6669672E6175746F5374617274496E74657276616C203D2066616C73653B0A2020202020202020636F6E6669672E6C617374456E64496E74';
wwv_flow_api.g_varchar2_table(31) := '657276616C203D2035303B0A0A202020202020202069662028696E69744A5320262620696E69744A5320696E7374616E63656F662046756E6374696F6E29207B0A202020202020202020202020696E69744A532E63616C6C28746869732C20636F6E6669';
wwv_flow_api.g_varchar2_table(32) := '67293B0A20202020202020207D0A0A20202020202020206C6574206974656D4E616D65203D20636F6E6669672E6E616D653B0A20202020202020206C6574206974656D24203D202428272327202B206974656D4E616D65293B0A20202020202020206C65';
wwv_flow_api.g_varchar2_table(33) := '74206974656D436F6E7461696E657224203D202428272327202B206974656D4E616D65202B20275F434F4E5441494E455227293B0A20202020202020206C6574206974656D5772617070657224203D202428272327202B206974656D4E616D65202B2027';
wwv_flow_api.g_varchar2_table(34) := '5F5752415050455227293B0A20202020202020206C65742070726253656C6563746F72203D206974656D4E616D65202B20275F57524150504552273B0A20202020202020206C657420746172676574456C203D206974656D436F6E7461696E6572242E66';
wwv_flow_api.g_varchar2_table(35) := '696E6428272E27202B205052425F434F4E5441494E45525F434C53293B0A20202020202020206C6574206D7367426F782C20706374426F783B0A0A20202020202020206C657420637265617465546172676574426F78203D2066756E6374696F6E202870';
wwv_flow_api.g_varchar2_table(36) := '6F732C207479706529207B0A2020202020202020202020206C657420656C24203D202428273C7370616E20636C6173733D22666F732D7072622D27202B2074797065202B20272D626F78223E3C2F7370616E3E27293B0A20202020202020202020202069';
wwv_flow_api.g_varchar2_table(37) := '662028706F73203D3D202761626F76652D656C656D656E742729207B0A20202020202020202020202020202020746172676574456C2E70726570656E6428656C24293B0A2020202020202020202020207D20656C73652069662028706F73203D3D202762';
wwv_flow_api.g_varchar2_table(38) := '656C6F772D656C656D656E742729207B0A20202020202020202020202020202020746172676574456C2E617070656E6428656C24293B0A2020202020202020202020207D0A20202020202020202020202072657475726E20656C243B0A20202020202020';
wwv_flow_api.g_varchar2_table(39) := '207D0A0A20202020202020206C6574206D6572676556616C756573203D2066756E6374696F6E202870637456616C75652C206D736756616C7565203D20636F6E6669672E6D736729207B0A2020202020202020202020206C657420636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(40) := '203D202428273C7370616E3E3C2F7370616E3E27293B0A20202020202020202020202069662028706374426F7829207B0A20202020202020202020202020202020706374426F782E7465787428676574506374286974656D4E616D652C2070637456616C';
wwv_flow_api.g_varchar2_table(41) := '756529202B20272527293B0A2020202020202020202020202020202069662028636F6E6669672E73686F77506374203D3D20276F6E2D656C656D656E742729207B0A2020202020202020202020202020202020202020636F6E7461696E65722E61707065';
wwv_flow_api.g_varchar2_table(42) := '6E6428706374426F78293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A202020202020202020202020696620286D7367426F7820262620636F6E6669672E73686F774D7367203D3D20276F6E2D656C656D656E74';
wwv_flow_api.g_varchar2_table(43) := '2729207B0A20202020202020202020202020202020636F6E7461696E65722E617070656E64286D7367426F78293B0A2020202020202020202020207D0A0A20202020202020202020202072657475726E20636F6E7461696E65725B305D3B0A2020202020';
wwv_flow_api.g_varchar2_table(44) := '2020207D3B0A0A20202020202020202F2F206170706C792074686520686569676874200A202020202020202069662028636F6E6669672E68656967687420262620636F6E6669672E68656967687420213D20272729207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(45) := '6974656D57726170706572242E6373732827686569676874272C20636F6E6669672E686569676874293B0A20202020202020207D0A0A20202020202020202F2F206261736963206F7074696F6E73206F626A6563740A20202020202020206C6574207072';
wwv_flow_api.g_varchar2_table(46) := '624F7074203D207B0A2020202020202020202020207374726F6B6557696474683A20636F6E6669672E7374726F6B6557696474682C0A202020202020202020202020656173696E673A2067657443616D656C4361736528636F6E6669672E616E696D6174';
wwv_flow_api.g_varchar2_table(47) := '696F6E292C0A2020202020202020202020206475726174696F6E3A207061727365496E7428636F6E6669672E6475726174696F6E292C0A202020202020202020202020636F6C6F723A20636F6E6669672E636F6C6F722C0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(48) := '747261696C436F6C6F723A20636F6E6669672E747261696C436F6C6F722C0A202020202020202020202020747261696C57696474683A20636F6E6669672E747261696C57696474682C0A2020202020202020202020207376675374796C653A207B0A2020';
wwv_flow_api.g_varchar2_table(49) := '202020202020202020202020202077696474683A202731303025272C0A202020202020202020202020202020206865696768743A202731303025270A2020202020202020202020207D0A20202020202020207D3B0A0A20202020202020202F2F20736574';
wwv_flow_api.g_varchar2_table(50) := '20746865206772616469656E742076616C7565730A202020202020202069662028636F6E6669672E7374796C65203D3D20276772616469656E742729207B0A2020202020202020202020207072624F70742E66726F6D203D207B20636F6C6F723A20636F';
wwv_flow_api.g_varchar2_table(51) := '6E6669672E636F6C6F72207D3B0A2020202020202020202020207072624F70742E746F203D207B20636F6C6F723A20636F6E6669672E656E64436F6C6F72207D3B0A20202020202020207D0A0A20202020202020202F2F2066756E6374696F6E20746861';
wwv_flow_api.g_varchar2_table(52) := '742077696C6C206265206578656375746564207769746820657665727920737465700A20202020202020202F2F207570646174652070637420616E64206D6573736167650A20202020202020202F2F2073657420746865207374726F6B6520636F6C6F72';
wwv_flow_api.g_varchar2_table(53) := '0A20202020202020207072624F70742E73746570203D202873746174652C2062617229203D3E207B0A2020202020202020202020206966202828706374426F78207C7C206D7367426F782920262620747970656F66206261722E73657454657874203D3D';
wwv_flow_api.g_varchar2_table(54) := '3D202766756E6374696F6E2729207B0A202020202020202020202020202020206261722E73657454657874286D6572676556616C756573286261722E76616C7565282929293B0A2020202020202020202020207D0A0A2020202020202020202020206966';
wwv_flow_api.g_varchar2_table(55) := '2028636F6E6669672E7374796C65203D3D20276772616469656E742729207B0A202020202020202020202020202020206261722E706174682E73657441747472696275746528277374726F6B65272C2073746174652E636F6C6F72293B0A202020202020';
wwv_flow_api.g_varchar2_table(56) := '2020202020207D0A20202020202020207D0A0A20202020202020202F2F20637265617465207468652070637420656C656D656E740A202020202020202069662028636F6E6669672E73686F7750637420213D20276E6F2729207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(57) := '202020706374426F78203D20637265617465546172676574426F7828636F6E6669672E73686F775063742C202770637427293B0A20202020202020207D0A0A20202020202020202F2F2063726561746520746865206D736720656C656D656E740A202020';
wwv_flow_api.g_varchar2_table(58) := '202020202069662028636F6E6669672E73686F774D736720213D20276E6F2729207B0A2020202020202020202020206D7367426F78203D20637265617465546172676574426F7828636F6E6669672E73686F774D73672C20276D736727293B0A20202020';
wwv_flow_api.g_varchar2_table(59) := '202020207D0A0A20202020202020202F2F20666F722074686520226F6E2D656C656D656E742220706F736974696F6E2077652075736520746865206170692070726F766964656420627920746865206C6962726172790A20202020202020202F2F20666F';
wwv_flow_api.g_varchar2_table(60) := '7220746865206F7468657220706F736974696F6E207765206372656174652074686520656C656D656E74730A202020202020202069662028636F6E6669672E73686F77506374203D3D20276F6E2D656C656D656E7427207C7C20636F6E6669672E73686F';
wwv_flow_api.g_varchar2_table(61) := '774D7367203D3D20276F6E2D656C656D656E742729207B0A2020202020202020202020207072624F70742E74657874203D207B0A2020202020202020202020202020202076616C75653A206D6572676556616C75657328636F6E6669672E70637456616C';
wwv_flow_api.g_varchar2_table(62) := '75652C20636F6E6669672E6D7367292C0A20202020202020202020202020202020636C6173734E616D653A20676574436C7328636F6E6669672E73686F775063742C20636F6E6669672E73686F774D7367292C0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(63) := '616C69676E546F426F74746F6D3A2066616C73652C202F2F206F6E6C79206170706C696573206F6E2073656D692D636972636C650A202020202020202020202020202020206175746F5374796C65436F6E7461696E65723A20747275652C0A2020202020';
wwv_flow_api.g_varchar2_table(64) := '20202020202020202020207374796C653A207B0A2020202020202020202020202020202020202020636F6C6F723A20636F6E6669672E6D7367436F6C6F720A202020202020202020202020202020207D0A2020202020202020202020207D3B0A20202020';
wwv_flow_api.g_varchar2_table(65) := '202020207D0A0A20202020202020202F2F2069662069742773206120637573746F6D2073686170652C2077652067657420282F7365742C2069662069742773206E6F74207365742920746865204944206F6620746865207061746820656C656D656E740A';
wwv_flow_api.g_varchar2_table(66) := '202020202020202069662028636F6E6669672E7368617065203D3D2027637573746F6D2729207B0A2020202020202020202020206C6574207061746873203D206974656D57726170706572242E66696E6428277061746827293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(67) := '20202070726253656C6563746F72203D206974656D4E616D65202B20275F666F7350726250617468273B0A2020202020202020202020206966202870617468732E6C656E677468203D3D203029207B0A2020202020202020202020202020202072657475';
wwv_flow_api.g_varchar2_table(68) := '726E3B0A2020202020202020202020207D0A20202020202020202020202070617468735B70617468732E6C656E677468203D3D2032203F2031203A20305D2E73657441747472696275746528276964272C2070726253656C6563746F72293B0A20202020';
wwv_flow_api.g_varchar2_table(69) := '202020207D0A0A20202020202020202F2F20696E697469616C697A65207468652070726F67726573736261720A20202020202020206C657420707262203D206E65772050726F67726573734261725B676574536861706528636F6E6669672E7368617065';
wwv_flow_api.g_varchar2_table(70) := '295D28272327202B2070726253656C6563746F722C207072624F7074293B0A20202020202020202F2F207765206E65656420746F206D616E75616C6C7920736574206F7572207465787420666F7220637573746F6D207368617065730A20202020202020';
wwv_flow_api.g_varchar2_table(71) := '2069662028636F6E6669672E7368617065203D3D2027637573746F6D2729207B0A2020202020202020202020207072622E73657454657874203D2066756E6374696F6E20287465787429207B0A2020202020202020202020207D0A20202020202020207D';
wwv_flow_api.g_varchar2_table(72) := '0A20202020202020202F2F20636F6D70757465207468652076616C75650A20202020202020206C657420737461727456616C7565203D20636F6D7075746556616C7565286974656D4E616D652C20636F6E6669672E70637456616C29202F203130303B0A';
wwv_flow_api.g_varchar2_table(73) := '20202020202020202F2F20736574207468652076616C75650A20202020202020207072622E73657428737461727456616C7565293B0A0A20202020202020202F2F2073657420746865206D6573736167650A20202020202020206C6574206D7367456C20';
wwv_flow_api.g_varchar2_table(74) := '3D206974656D436F6E7461696E6572242E66696E6428272E27202B204D53475F434C53293B0A2020202020202020696620286D7367456C2E6C656E677468203E203029207B0A2020202020202020202020206D7367456C2E7465787428636F6E6669672E';
wwv_flow_api.g_varchar2_table(75) := '6D736756616C207C7C20636F6E6669672E6D7367293B0A20202020202020207D0A0A20202020202020202F2F2071756575652074686520616E696D6174696F6E730A20202020202020206C6574207175657565203D205B5D3B0A20202020202020206C65';
wwv_flow_api.g_varchar2_table(76) := '742071756575497352756E6E696E67203D2066616C73653B0A0A202020202020202066756E6374696F6E2072756E51756575652829207B0A20202020202020202020202071756575497352756E6E696E67203D20747275653B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(77) := '20206966202871756575652E6C656E677468203D3D203029207B0A2020202020202020202020202020202071756575497352756E6E696E67203D2066616C73653B0A2020202020202020202020202020202072657475726E3B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(78) := '20207D0A2020202020202020202020207072622E616E696D6174652871756575655B305D2E616E696D61746556616C75652C2066756E6374696F6E202829207B0A202020202020202020202020202020202F2F207472696767657220636F6D706C657465';
wwv_flow_api.g_varchar2_table(79) := '206576656E740A202020202020202020202020202020206966202871756575655B305D2E6E657756616C7565203D3D204D41585F56414C554529207B0A2020202020202020202020202020202020202020617065782E6576656E742E7472696767657228';
wwv_flow_api.g_varchar2_table(80) := '272327202B206974656D4E616D652C204556454E545F434F4D504C455445293B0A202020202020202020202020202020207D0A202020202020202020202020202020202F2F2072656D6F76652074686520616E696D6174696F6E2066726F6D2074686520';
wwv_flow_api.g_varchar2_table(81) := '717565750A2020202020202020202020202020202071756575652E736869667428293B0A202020202020202020202020202020202F2F206578656374756520746865206E65787420616E696D6174696F6E0A202020202020202020202020202020207275';
wwv_flow_api.g_varchar2_table(82) := '6E517565756528293B0A2020202020202020202020207D293B0A20202020202020207D0A0A20202020202020202F2F20637265617465207468652041504558206974656D20696E746572666163650A2020202020202020617065782E6974656D2E637265';
wwv_flow_api.g_varchar2_table(83) := '617465286974656D4E616D652C207B0A20202020202020202020202067657456616C75653A2066756E6374696F6E202829207B0A2020202020202020202020202020202072657475726E206974656D242E76616C28293B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(84) := '7D2C0A20202020202020202020202073657456616C75653A2066756E6374696F6E202876616C756529207B0A202020202020202020202020202020202F2F20636865636B207468652070726F76696465642076616C75652C207765206D69676874206265';
wwv_flow_api.g_varchar2_table(85) := '2073657474696E6720746865206D65737361676520746F6F0A20202020202020202020202020202020696620286D7367426F782026262028747970656F662076616C7565203D3D3D2027737472696E6727207C7C2076616C756520696E7374616E63656F';
wwv_flow_api.g_varchar2_table(86) := '6620537472696E672929207B0A20202020202020202020202020202020202020206C6574206D756C746956616C7565203D2076616C75652E73706C697428273A27293B0A2020202020202020202020202020202020202020696620286D756C746956616C';
wwv_flow_api.g_varchar2_table(87) := '75652E6C656E677468203E203129207B0A2020202020202020202020202020202020202020202020202F2F2077652077616E7420746F2073657420746865206D657373616765206F6E6365206F757220616E696D6174696F6E206475726174696F6E2063';

wwv_flow_api.g_varchar2_table(88) := '6F6D706C657465730A20202020202020202020202020202020202020202020202073657454696D656F75742866756E6374696F6E202829207B0A202020202020202020202020202020202020202020202020202020202F2F206974277320706F73736962';
wwv_flow_api.g_varchar2_table(89) := '6C652074686579206D617920696E636C756465206120636F6C6F6E20696E207468656972206D6573736167652076616C75650A202020202020202020202020202020202020202020202020202020206D7367456C2E74657874286D756C746956616C7565';
wwv_flow_api.g_varchar2_table(90) := '2E736C6963652831292E6A6F696E28273A2729293B0A2020202020202020202020202020202020202020202020207D2C20636F6E6669672E6475726174696F6E293B0A20202020202020202020202020202020202020207D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(91) := '20202020207D0A202020202020202020202020202020206C6574206E657756616C7565203D20636F6D7075746556616C7565286974656D4E616D652C2076616C7565293B0A202020202020202020202020202020206974656D242E76616C286E65775661';
wwv_flow_api.g_varchar2_table(92) := '6C7565293B0A202020202020202020202020202020202F2F2074686520616E696D6174696F6E2076616C7565206D75737420626520696E207468652072616E67652030202D20312E300A202020202020202020202020202020206C657420616E696D6174';
wwv_flow_api.g_varchar2_table(93) := '6556616C7565203D206E657756616C7565202F203130303B0A2020202020202020202020202020202069662028636F6E6669672E7175657565416E696D6174696F6E7329207B0A20202020202020202020202020202020202020202F2F2061646420616E';
wwv_flow_api.g_varchar2_table(94) := '696D6174696F6E20746F207468652071756575650A202020202020202020202020202020202020202071756575652E70757368287B20616E696D61746556616C75652C206E657756616C7565207D293B0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(95) := '202F2F2073746172742074686520657865637574696F6E202869662069742773206E6F74207374617274656420796574290A2020202020202020202020202020202020202020696620282171756575497352756E6E696E6729207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(96) := '2020202020202020202020202020202072756E517565756528293B0A20202020202020202020202020202020202020207D3B0A202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020207072622E';
wwv_flow_api.g_varchar2_table(97) := '616E696D61746528616E696D61746556616C75652C2066756E6374696F6E202829207B0A2020202020202020202020202020202020202020202020202F2F207472696767657220636F6D706C657465206576656E740A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(98) := '20202020202020202020696620286E657756616C7565203D3D204D41585F56414C554529207B0A20202020202020202020202020202020202020202020202020202020617065782E6576656E742E7472696767657228272327202B206974656D4E616D65';
wwv_flow_api.g_varchar2_table(99) := '2C204556454E545F434F4D504C455445293B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(100) := '2C0A2020202020202020202020206765744D6573736167653A2066756E6374696F6E202829207B0A20202020202020202020202020202020696620286D7367426F7829207B0A202020202020202020202020202020202020202072657475726E206D7367';
wwv_flow_api.g_varchar2_table(101) := '426F782E7465787428293B0A202020202020202020202020202020207D0A2020202020202020202020202020202072657475726E2027273B0A2020202020202020202020207D2C0A2020202020202020202020207365744D6573736167653A2066756E63';
wwv_flow_api.g_varchar2_table(102) := '74696F6E20286D736729207B0A20202020202020202020202020202020696620286D7367426F7829207B0A20202020202020202020202020202020202020206D7367456C2E74657874286D7367293B0A202020202020202020202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(103) := '202020202020202020207D2C0A202020202020202020202020676574496E7374616E63653A2066756E6374696F6E202829207B0A2020202020202020202020202020202072657475726E207072623B0A2020202020202020202020207D2C0A2020202020';
wwv_flow_api.g_varchar2_table(104) := '20202020202020726566726573683A2066756E6374696F6E202829207B0A202020202020202020202020202020206C65742073656C66203D20746869733B0A202020202020202020202020202020206C657420726573756C74203D20617065782E736572';
wwv_flow_api.g_varchar2_table(105) := '7665722E706C7567696E28636F6E6669672E616A617849642C207B0A2020202020202020202020202020202020202020706167654974656D733A20636F6E6669672E6974656D73546F5375626D69740A202020202020202020202020202020207D2C207B';
wwv_flow_api.g_varchar2_table(106) := '0A2020202020202020202020202020202020202020726566726573684F626A6563743A20272327202B206974656D4E616D652C0A2020202020202020202020202020202020202020726566726573684F626A656374446174613A20636F6E6669670A2020';
wwv_flow_api.g_varchar2_table(107) := '20202020202020202020202020207D293B0A20202020202020202020202020202020617065782E6576656E742E7472696767657228272327202B206974656D4E616D652C204556454E545F4245464F52455F524546524553482C20636F6E666967293B0A';
wwv_flow_api.g_varchar2_table(108) := '20202020202020202020202020202020726573756C742E646F6E652866756E6374696F6E20286461746129207B0A202020202020202020202020202020202020202069662028646174612E7375636365737329207B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(109) := '2020202020202020202073656C662E73657456616C756528646174612E76616C7565207C7C2030293B0A20202020202020202020202020202020202020202020202069662028646174612E6D736729207B0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(110) := '202020202020202020202F2F2077652077616E7420746F2073657420746865206D657373616765206F6E6365206F757220616E696D6174696F6E206475726174696F6E20636F6D706C657465730A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(111) := '20202020202073657454696D656F75742866756E6374696F6E202829207B0A20202020202020202020202020202020202020202020202020202020202020206966202873656C662E63616C6C6261636B7329207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(112) := '20202020202020202020202020202020202020202073656C662E63616C6C6261636B732E7365744D65737361676528646174612E6D7367293B0A20202020202020202020202020202020202020202020202020202020202020207D20656C7365207B0A20';
wwv_flow_api.g_varchar2_table(113) := '202020202020202020202020202020202020202020202020202020202020202020202073656C662E7365744D65737361676528646174612E6D7367293B0A20202020202020202020202020202020202020202020202020202020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(114) := '2020202020202020202020202020202020202020202020207D2C20636F6E6669672E6475726174696F6E293B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A20202020202020';
wwv_flow_api.g_varchar2_table(115) := '2020202020202020207D292E6661696C2866756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A2020202020202020202020202020202020202020617065782E64656275672E6572726F72282746';
wwv_flow_api.g_varchar2_table(116) := '4F53202D2050726F677265737320426172202D2052656672657368206661696C65643A2027202B206572726F725468726F776E293B0A202020202020202020202020202020207D292E616C776179732866756E6374696F6E202829207B0A202020202020';
wwv_flow_api.g_varchar2_table(117) := '2020202020202020202020202020617065782E6576656E742E7472696767657228272327202B206974656D4E616D652C204556454E545F41465445525F524546524553482C20636F6E666967293B0A202020202020202020202020202020207D290A2020';
wwv_flow_api.g_varchar2_table(118) := '202020202020202020207D2C0A2020202020202020202020207374617274496E74657276616C3A2066756E6374696F6E202829207B0A2020202020202020202020202020202069662028636F6E6669672E61646454696D657229207B0A20202020202020';
wwv_flow_api.g_varchar2_table(119) := '20202020202020202020202020696E74657276616C537461727428293B0A202020202020202020202020202020207D0A2020202020202020202020207D2C0A202020202020202020202020656E64496E74657276616C3A2066756E6374696F6E20282920';
wwv_flow_api.g_varchar2_table(120) := '7B0A2020202020202020202020202020202069662028636F6E6669672E61646454696D657229207B0A2020202020202020202020202020202020202020636C656172496E74657276616C28696E74657276616C293B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(121) := '202020202020696E74657276616C203D2027273B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D293B0A0A20202020202020206C657420696E74657276616C3B0A20202020202020206C657420';
wwv_flow_api.g_varchar2_table(122) := '696E74657276616C5374617274203D2066756E6374696F6E202829207B0A20202020202020202020202069662028696E74657276616C29207B0A20202020202020202020202020202020617065782E64656275672E696E666F2827464F53202D2050726F';
wwv_flow_api.g_varchar2_table(123) := '6772657373204261723A2054686520696E74657276616C20697320616C72656164792072756E6E696E672E27290A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A2020202020202020202020206C657420';
wwv_flow_api.g_varchar2_table(124) := '696E74657276616C53203D207061727365496E7428636F6E6669672E72656672657368496E74657276616C293B0A2020202020202020202020206C6574206E756D4F6652657073203D207061727365496E7428636F6E6669672E6E756D4F665265707320';
wwv_flow_api.g_varchar2_table(125) := '7C7C2030293B0A2020202020202020202020206C657420636F756E746572203D20303B0A202020202020202020202020696E74657276616C203D20736574496E74657276616C2866756E6374696F6E202829207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(126) := '20636F756E7465722B2B3B0A2020202020202020202020202020202069662028636F6E6669672E72657065746974696F6E73203D3D202770726F67726573732D69732D636F6D706C6574652729207B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(127) := '696620287061727365496E7428617065782E6974656D286974656D4E616D65292E67657456616C7565282929203E3D2031303029207B0A202020202020202020202020202020202020202020202020656E64496E74657276616C28696E74657276616C29';
wwv_flow_api.g_varchar2_table(128) := '3B0A20202020202020202020202020202020202020202020202072657475726E3B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D20656C73652069662028636F6E6669672E72657065746974696F6E';
wwv_flow_api.g_varchar2_table(129) := '73203D3D20276E756D6265722D6F662D72657065746974696F6E732729207B0A2020202020202020202020202020202020202020696620286E756D4F6652657073203C3D20636F756E74657229207B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(130) := '20202020656E64496E74657276616C28696E74657276616C293B0A20202020202020202020202020202020202020202020202072657475726E3B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A';
wwv_flow_api.g_varchar2_table(131) := '2020202020202020202020202020202069662028636F756E746572203E20636F6E6669672E6C617374456E64496E74657276616C29207B0A2020202020202020202020202020202020202020656E64496E74657276616C28696E74657276616C293B0A20';
wwv_flow_api.g_varchar2_table(132) := '2020202020202020202020202020202020202072657475726E3B0A202020202020202020202020202020207D0A20202020202020202020202020202020617065782E6974656D286974656D4E616D65292E7265667265736828293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(133) := '202020207D2C20696E74657276616C53293B0A20202020202020207D0A0A202020202020202069662028636F6E6669672E61646454696D657220262620636F6E6669672E6175746F5374617274496E74657276616C29207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(134) := '20696E74657276616C537461727428293B0A20202020202020207D3B0A0A20202020202020206C657420656E64496E74657276616C203D2066756E6374696F6E202829207B0A202020202020202020202020636C656172496E74657276616C28696E7465';
wwv_flow_api.g_varchar2_table(135) := '7276616C293B0A202020202020202020202020696E74657276616C203D2027273B0A202020202020202020202020617065782E6576656E742E7472696767657228272327202B206974656D4E616D652C204556454E545F494E54455256414C5F4F564552';
wwv_flow_api.g_varchar2_table(136) := '293B0A20202020202020207D3B0A0A202020207D3B0A0A202020206C65742067657443616D656C43617365203D2066756E6374696F6E2028776F72642C206669727374436170203D2066616C736529207B0A20202020202020206C657420617272203D20';
wwv_flow_api.g_varchar2_table(137) := '776F72642E73706C697428272D27293B0A20202020202020206C657420706172742C20726573756C74203D2027273B0A0A2020202020202020696620286172722E6C656E677468203C203129207B0A20202020202020202020202072657475726E207265';
wwv_flow_api.g_varchar2_table(138) := '73756C743B0A20202020202020207D3B0A0A202020202020202069662028666972737443617029207B0A2020202020202020202020206172725B305D203D206172725B305D5B305D2E746F5570706572436173652829202B206172725B305D2E73756273';
wwv_flow_api.g_varchar2_table(139) := '74722831293B0A20202020202020207D0A0A2020202020202020666F7220286C65742069203D20303B2069203C206172722E6C656E6774683B20692B2B29207B0A20202020202020202020202070617274203D206172725B695D3B0A2020202020202020';
wwv_flow_api.g_varchar2_table(140) := '202020206966202869203E203029207B0A2020202020202020202020202020202070617274203D20706172745B305D2E746F5570706572436173652829202B20706172742E737562737472696E672831293B0A2020202020202020202020207D0A202020';
wwv_flow_api.g_varchar2_table(141) := '202020202020202020726573756C74202B3D20706172743B0A20202020202020207D0A202020202020202072657475726E20726573756C743B0A202020207D0A0A202020206C6574206765745368617065203D2066756E6374696F6E2028736861706529';
wwv_flow_api.g_varchar2_table(142) := '207B0A2020202020202020696620287368617065203D3D2027637573746F6D2729207B0A20202020202020202020202072657475726E202750617468273B0A20202020202020207D20656C7365207B0A20202020202020202020202072657475726E2067';
wwv_flow_api.g_varchar2_table(143) := '657443616D656C436173652873686170652C2074727565293B0A20202020202020207D0A202020207D0A0A202020206C657420676574436C73203D2066756E6374696F6E20287063742C206D736729207B0A20202020202020206C657420726573756C74';
wwv_flow_api.g_varchar2_table(144) := '3B0A202020202020202069662028706374203D3D20276F6E2D656C656D656E7427207C7C206D7367203D3D20276F6E2D656C656D656E742729207B0A202020202020202020202020726573756C74203D2027666F732D7072622D6F6E2D656C656D656E74';
wwv_flow_api.g_varchar2_table(145) := '273B0A20202020202020207D20656C7365207B0A20202020202020202020202069662028706374203D3D202761626F76652D656C656D656E742729207B0A20202020202020202020202020202020726573756C74203D2027666F732D7072622D61626F76';
wwv_flow_api.g_varchar2_table(146) := '652D656C656D656E74273B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020726573756C74203D2027666F732D7072622D62656C6F772D656C656D656E74273B0A2020202020202020202020207D0A202020';
wwv_flow_api.g_varchar2_table(147) := '20202020207D0A202020202020202072657475726E20726573756C743B0A202020207D0A0A202020206C657420636F6D7075746556616C7565203D2066756E6374696F6E20286974656D4E616D652C2076616C756529207B0A20202020202020206C6574';
wwv_flow_api.g_varchar2_table(148) := '2076616C75654E756D203D207061727365496E742876616C756529207C7C20303B0A20202020202020206966202876616C75654E756D203E3D204D41585F56414C554529207B0A20202020202020202020202072657475726E204D41585F56414C55453B';
wwv_flow_api.g_varchar2_table(149) := '0A20202020202020207D20656C7365206966202876616C75654E756D203C3D204D494E5F56414C554529207B0A20202020202020202020202072657475726E204D494E5F56414C55450A20202020202020207D20656C7365207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(150) := '20202072657475726E2076616C75654E756D3B0A20202020202020207D0A202020207D0A0A202020206C657420676574506374203D2066756E6374696F6E20286974656D4E616D652C2076616C7565203D203029207B0A20202020202020206C65742070';
wwv_flow_api.g_varchar2_table(151) := '6374203D207061727365496E742876616C756529203C3D2031203F204D6174682E726F756E642876616C7565202A2031303029203A2076616C75653B0A202020202020202072657475726E20636F6D7075746556616C7565286974656D4E616D652C2070';
wwv_flow_api.g_varchar2_table(152) := '6374293B0A202020207D0A0A2020202072657475726E207B0A2020202020202020696E69740A202020207D0A7D292829';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(217660946683991491)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E666F732D7072622D636F6E7461696E6572207B0A2020202077696474683A20313030253B0A2020202070616464696E673A203570783B0A20202020746578742D616C69676E3A2063656E7465723B0A7D0A0A2E666F732D7072622D7063742D626F782C';
wwv_flow_api.g_varchar2_table(2) := '202E666F732D7072622D6D73672D626F78207B0A2020202070616464696E673A2030203570783B0A202020206D617267696E3A206175746F3B0A20202020746578742D616C69676E3A2063656E7465723B0A202020202F2A20646973706C61793A20626C';
wwv_flow_api.g_varchar2_table(3) := '6F636B3B202A2F0A7D0A0A2E666F732D7072622D6F6E2D656C656D656E74202E666F732D7072622D7063742D626F782C202E666F732D7072622D6F6E2D656C656D656E74202E666F732D7072622D6D73672D626F78207B0A202020206D617267696E3A20';
wwv_flow_api.g_varchar2_table(4) := '756E7365743B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A7D0A0A2E666F732D7072622D6D7367207B0A2020202070616464696E673A203020313070783B0A202020206D617267696E3A206175746F3B0A20202020746578742D';
wwv_flow_api.g_varchar2_table(5) := '616C69676E3A2063656E7465723B0A7D0A0A2E666F732D7072622D74657874207B0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0A7D0A0A2F2A204C696E65202A2F0A6469762E742D466F726D2D6669656C64436F6E7461696E6572';
wwv_flow_api.g_varchar2_table(6) := '202E666F732D7072622D777261707065722E666F732D7072622D6C696E6520207B0A202020206865696768743A20323470783B0A7D0A0A6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64';
wwv_flow_api.g_varchar2_table(7) := '436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D6C696E6520207B0A202020206865696768743A20323870783B0A7D0A0A6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C617267652E742D';
wwv_flow_api.g_varchar2_table(8) := '466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D6C696E6520207B0A202020206865696768743A20333270783B0A7D0A0A2F2A20436972636C65202A2F0A6469762E742D466F726D2D6669';
wwv_flow_api.g_varchar2_table(9) := '656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D636972636C65207B0A202020206865696768743A2031303470783B0A7D0A0A6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267';
wwv_flow_api.g_varchar2_table(10) := '652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D636972636C65207B0A202020206865696768743A2031313270783B0A7D0A0A6469762E742D466F726D2D6669656C64436F6E74';
wwv_flow_api.g_varchar2_table(11) := '61696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D636972636C65207B0A202020206865696768743A2031323070783B0A7D0A0A2F2A2053656D692D';
wwv_flow_api.g_varchar2_table(12) := '636972636C65202A2F0A6469762E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D73656D692D636972636C65207B0A202020206865696768743A2031303470783B0A7D0A0A646976';
wwv_flow_api.g_varchar2_table(13) := '2E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D73656D692D636972636C65207B0A202020206865696768';
wwv_flow_api.g_varchar2_table(14) := '743A2031313270783B0A7D0A0A6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D73656D692D63';
wwv_flow_api.g_varchar2_table(15) := '6972636C65207B0A202020206865696768743A2031323070783B0A7D0A0A2F2A20437573746F6D202A2F0A6469762E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D637573746F6D';
wwv_flow_api.g_varchar2_table(16) := '207B0A202020206865696768743A2031303470783B0A2020202077696474683A20313030253B0A7D0A0A6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F';
wwv_flow_api.g_varchar2_table(17) := '732D7072622D777261707065722E666F732D7072622D637573746F6D207B0A202020206865696768743A2031313270783B0A2020202077696474683A20313030253B0A7D0A0A6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C61';
wwv_flow_api.g_varchar2_table(18) := '7267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D637573746F6D207B0A202020206865696768743A2031323070783B0A2020202077696474683A20313030253B0A7D0A0A2E';
wwv_flow_api.g_varchar2_table(19) := '666F732D7072622D777261707065722E666F732D7072622D637573746F6D20737667207B0A2020202077696474683A20313030253B0A202020206865696768743A20313030253B0A7D0A0A2F2A206F6E2D656C656D656E74202A2F0A2E666F732D707262';
wwv_flow_api.g_varchar2_table(20) := '2D6F6E2D656C656D656E74207B0A20202020706F736974696F6E3A206162736F6C7574653B0A202020206C6566743A203530253B0A20202020746F703A203530253B0A2020202070616464696E673A20303B0A202020206D617267696E3A20303B0A2020';
wwv_flow_api.g_varchar2_table(21) := '20207472616E73666F726D3A207472616E736C617465282D3530252C202D353025290A7D0A0A2E666F732D7072622D73656D692D636972636C65202E666F732D7072622D6F6E2D656C656D656E74207B0A20202020706F736974696F6E3A206162736F6C';
wwv_flow_api.g_varchar2_table(22) := '7574653B0A202020206C6566743A203530253B0A20202020746F703A2035302521696D706F7274616E743B0A2020202070616464696E673A20303B0A202020206D617267696E3A20303B0A7D0A0A2F2A2061626F76652D656C656D656E74202A2F0A2E66';
wwv_flow_api.g_varchar2_table(23) := '6F732D7072622D6C696E65202E666F732D7072622D61626F76652D656C656D656E74207B0A20202020706F736974696F6E3A206162736F6C7574653B0A202020206C6566743A203530253B0A20202020746F703A20303B0A2020202070616464696E673A';
wwv_flow_api.g_varchar2_table(24) := '20303B0A202020206D617267696E3A20303B0A7D0A0A2E666F732D7072622D636972636C65202E666F732D7072622D61626F76652D656C656D656E74207B0A20202020706F736974696F6E3A206162736F6C7574653B0A202020206C6566743A20343925';
wwv_flow_api.g_varchar2_table(25) := '3B0A20202020746F703A20303B0A2020202070616464696E673A20303B0A202020206D617267696E3A20303B0A7D0A0A2E666F732D7072622D73656D692D636972636C65202E666F732D7072622D61626F76652D656C656D656E74207B0A20202020706F';
wwv_flow_api.g_varchar2_table(26) := '736974696F6E3A206162736F6C7574653B0A202020206C6566743A203439253B0A20202020746F703A203021696D706F7274616E743B0A2020202070616464696E673A20303B0A202020206D617267696E3A20303B0A202020207472616E73666F726D3A';
wwv_flow_api.g_varchar2_table(27) := '20756E73657421696D706F7274616E743B0A7D0A0A2F2A2062656C6F772D656C656D656E74202A2F0A2E666F732D7072622D62656C6F772D656C656D656E74207B0A20202020626F74746F6D3A20303B0A2020202070616464696E673A20303B0A202020';
wwv_flow_api.g_varchar2_table(28) := '206D617267696E3A20303B0A20202020746578742D616C69676E3A2063656E7465723B0A202020207472616E73666F726D3A20756E73657421696D706F7274616E743B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(217661392161992312)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_file_name=>'css/style.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E464F533D77696E646F772E464F537C7C7B7D2C464F532E6974656D3D464F532E6974656D7C7C7B7D2C464F532E6974656D2E70726F67726573734261723D66756E6374696F6E28297B636F6E737420653D3130302C743D22666F735F70';
wwv_flow_api.g_varchar2_table(2) := '72625F70726F67726573735F636F6D706C657465223B6C6574206E3D66756E6374696F6E28652C743D2131297B6C6574206E2C723D652E73706C697428222D22292C6F3D22223B696628722E6C656E6774683C312972657475726E206F3B74262628725B';
wwv_flow_api.g_varchar2_table(3) := '305D3D725B305D5B305D2E746F55707065724361736528292B725B305D2E737562737472283129293B666F72286C657420653D303B653C722E6C656E6774683B652B2B296E3D725B655D2C653E302626286E3D6E5B305D2E746F55707065724361736528';
wwv_flow_api.g_varchar2_table(4) := '292B6E2E737562737472696E67283129292C6F2B3D6E3B72657475726E206F7D2C723D66756E6374696F6E2865297B72657475726E22637573746F6D223D3D653F2250617468223A6E28652C2130297D2C6F3D66756E6374696F6E28652C74297B6C6574';
wwv_flow_api.g_varchar2_table(5) := '206E3B72657475726E206E3D226F6E2D656C656D656E74223D3D657C7C226F6E2D656C656D656E74223D3D743F22666F732D7072622D6F6E2D656C656D656E74223A2261626F76652D656C656D656E74223D3D653F22666F732D7072622D61626F76652D';
wwv_flow_api.g_varchar2_table(6) := '656C656D656E74223A22666F732D7072622D62656C6F772D656C656D656E74222C6E7D2C733D66756E6374696F6E28742C6E297B6C657420723D7061727365496E74286E297C7C303B72657475726E20723E3D653F653A723C3D303F303A727D2C613D66';
wwv_flow_api.g_varchar2_table(7) := '756E6374696F6E28652C743D30297B6C6574206E3D7061727365496E742874293C3D313F4D6174682E726F756E64283130302A74293A743B72657475726E207328652C6E297D3B72657475726E7B696E69743A66756E6374696F6E28692C6C297B692E73';
wwv_flow_api.g_varchar2_table(8) := '74726F6B6557696474683D31302C692E747261696C57696474683D31302C692E6D7367436F6C6F723D2223303030303030222C692E6D73673D692E6D73677C7C224C6F6164696E672E2E2E222C692E6175746F5374617274496E74657276616C3D21312C';
wwv_flow_api.g_varchar2_table(9) := '692E6C617374456E64496E74657276616C3D35302C6C26266C20696E7374616E63656F662046756E6374696F6E26266C2E63616C6C28746869732C69293B6C657420752C662C633D692E6E616D652C673D24282223222B63292C703D24282223222B632B';
wwv_flow_api.g_varchar2_table(10) := '225F434F4E5441494E455222292C6D3D24282223222B632B225F5752415050455222292C683D632B225F57524150504552222C643D702E66696E6428222E666F732D7072622D636F6E7461696E657222292C623D66756E6374696F6E28652C74297B6C65';
wwv_flow_api.g_varchar2_table(11) := '74206E3D2428273C7370616E20636C6173733D22666F732D7072622D272B742B272D626F78223E3C2F7370616E3E27293B72657475726E2261626F76652D656C656D656E74223D3D653F642E70726570656E64286E293A2262656C6F772D656C656D656E';
wwv_flow_api.g_varchar2_table(12) := '74223D3D652626642E617070656E64286E292C6E7D2C763D66756E6374696F6E28652C743D692E6D7367297B6C6574206E3D2428223C7370616E3E3C2F7370616E3E22293B72657475726E2066262628662E74657874286128632C65292B222522292C22';
wwv_flow_api.g_varchar2_table(13) := '6F6E2D656C656D656E74223D3D692E73686F7750637426266E2E617070656E64286629292C752626226F6E2D656C656D656E74223D3D692E73686F774D736726266E2E617070656E642875292C6E5B305D7D3B692E68656967687426262222213D692E68';
wwv_flow_api.g_varchar2_table(14) := '656967687426266D2E6373732822686569676874222C692E686569676874293B6C657420783D7B7374726F6B6557696474683A692E7374726F6B6557696474682C656173696E673A6E28692E616E696D6174696F6E292C6475726174696F6E3A70617273';
wwv_flow_api.g_varchar2_table(15) := '65496E7428692E6475726174696F6E292C636F6C6F723A692E636F6C6F722C747261696C436F6C6F723A692E747261696C436F6C6F722C747261696C57696474683A692E747261696C57696474682C7376675374796C653A7B77696474683A2231303025';
wwv_flow_api.g_varchar2_table(16) := '222C6865696768743A2231303025227D7D3B696628226772616469656E74223D3D692E7374796C65262628782E66726F6D3D7B636F6C6F723A692E636F6C6F727D2C782E746F3D7B636F6C6F723A692E656E64436F6C6F727D292C782E737465703D2865';
wwv_flow_api.g_varchar2_table(17) := '2C74293D3E7B28667C7C752926262266756E6374696F6E223D3D747970656F6620742E736574546578742626742E73657454657874287628742E76616C7565282929292C226772616469656E74223D3D692E7374796C652626742E706174682E73657441';
wwv_flow_api.g_varchar2_table(18) := '747472696275746528227374726F6B65222C652E636F6C6F72297D2C226E6F22213D692E73686F77506374262628663D6228692E73686F775063742C227063742229292C226E6F22213D692E73686F774D7367262628753D6228692E73686F774D73672C';
wwv_flow_api.g_varchar2_table(19) := '226D73672229292C226F6E2D656C656D656E7422213D692E73686F775063742626226F6E2D656C656D656E7422213D692E73686F774D73677C7C28782E746578743D7B76616C75653A7628692E70637456616C75652C692E6D7367292C636C6173734E61';
wwv_flow_api.g_varchar2_table(20) := '6D653A6F28692E73686F775063742C692E73686F774D7367292C616C69676E546F426F74746F6D3A21312C6175746F5374796C65436F6E7461696E65723A21302C7374796C653A7B636F6C6F723A692E6D7367436F6C6F727D7D292C22637573746F6D22';
wwv_flow_api.g_varchar2_table(21) := '3D3D692E7368617065297B6C657420653D6D2E66696E6428227061746822293B696628683D632B225F666F7350726250617468222C303D3D652E6C656E6774682972657475726E3B655B323D3D652E6C656E6774683F313A305D2E736574417474726962';
wwv_flow_api.g_varchar2_table(22) := '75746528226964222C68297D6C657420773D6E65772850726F67726573734261725B7228692E7368617065295D29282223222B682C78293B22637573746F6D223D3D692E7368617065262628772E736574546578743D66756E6374696F6E2865297B7D29';
wwv_flow_api.g_varchar2_table(23) := '3B6C657420493D7328632C692E70637456616C292F3130303B772E7365742849293B6C6574205F3D702E66696E6428222E666F732D7072622D6D73672D626F7822293B5F2E6C656E6774683E3026265F2E7465787428692E6D736756616C7C7C692E6D73';
wwv_flow_api.g_varchar2_table(24) := '67293B6C657420502C533D5B5D2C543D21313B66756E6374696F6E204F28297B543D21302C30213D532E6C656E6774683F772E616E696D61746528535B305D2E616E696D61746556616C75652C2866756E6374696F6E28297B535B305D2E6E657756616C';
wwv_flow_api.g_varchar2_table(25) := '75653D3D652626617065782E6576656E742E74726967676572282223222B632C74292C532E736869667428292C4F28297D29293A543D21317D617065782E6974656D2E63726561746528632C7B67657456616C75653A66756E6374696F6E28297B726574';
wwv_flow_api.g_varchar2_table(26) := '75726E20672E76616C28297D2C73657456616C75653A66756E6374696F6E286E297B6966287526262822737472696E67223D3D747970656F66206E7C7C6E20696E7374616E63656F6620537472696E6729297B6C657420653D6E2E73706C697428223A22';
wwv_flow_api.g_varchar2_table(27) := '293B652E6C656E6774683E31262673657454696D656F7574282866756E6374696F6E28297B5F2E7465787428652E736C6963652831292E6A6F696E28223A2229297D292C692E6475726174696F6E297D6C657420723D7328632C6E293B672E76616C2872';
wwv_flow_api.g_varchar2_table(28) := '293B6C6574206F3D722F3130303B692E7175657565416E696D6174696F6E733F28532E70757368287B616E696D61746556616C75653A6F2C6E657756616C75653A727D292C547C7C4F2829293A772E616E696D617465286F2C2866756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(29) := '7B723D3D652626617065782E6576656E742E74726967676572282223222B632C74297D29297D2C6765744D6573736167653A66756E6374696F6E28297B72657475726E20753F752E7465787428293A22227D2C7365744D6573736167653A66756E637469';

wwv_flow_api.g_varchar2_table(30) := '6F6E2865297B7526265F2E746578742865297D2C676574496E7374616E63653A66756E6374696F6E28297B72657475726E20777D2C726566726573683A66756E6374696F6E28297B6C657420653D746869732C743D617065782E7365727665722E706C75';
wwv_flow_api.g_varchar2_table(31) := '67696E28692E616A617849642C7B706167654974656D733A692E6974656D73546F5375626D69747D2C7B726566726573684F626A6563743A2223222B632C726566726573684F626A656374446174613A697D293B617065782E6576656E742E7472696767';
wwv_flow_api.g_varchar2_table(32) := '6572282223222B632C22666F735F7072625F6265666F72655F72656672657368222C69292C742E646F6E65282866756E6374696F6E2874297B742E73756363657373262628652E73657456616C756528742E76616C75657C7C30292C742E6D7367262673';
wwv_flow_api.g_varchar2_table(33) := '657454696D656F7574282866756E6374696F6E28297B652E63616C6C6261636B733F652E63616C6C6261636B732E7365744D65737361676528742E6D7367293A652E7365744D65737361676528742E6D7367297D292C692E6475726174696F6E29297D29';
wwv_flow_api.g_varchar2_table(34) := '292E6661696C282866756E6374696F6E28652C742C6E297B617065782E64656275672E6572726F722822464F53202D2050726F677265737320426172202D2052656672657368206661696C65643A20222B6E297D29292E616C77617973282866756E6374';
wwv_flow_api.g_varchar2_table(35) := '696F6E28297B617065782E6576656E742E74726967676572282223222B632C22666F735F7072625F61667465725F72656672657368222C69297D29297D2C7374617274496E74657276616C3A66756E6374696F6E28297B692E61646454696D6572262656';
wwv_flow_api.g_varchar2_table(36) := '28297D2C656E64496E74657276616C3A66756E6374696F6E28297B692E61646454696D6572262628636C656172496E74657276616C2850292C503D2222297D7D293B6C657420563D66756E6374696F6E28297B696628502972657475726E20766F696420';
wwv_flow_api.g_varchar2_table(37) := '617065782E64656275672E696E666F2822464F53202D2050726F6772657373204261723A2054686520696E74657276616C20697320616C72656164792072756E6E696E672E22293B6C657420653D7061727365496E7428692E72656672657368496E7465';
wwv_flow_api.g_varchar2_table(38) := '7276616C292C743D7061727365496E7428692E6E756D4F66526570737C7C30292C6E3D303B503D736574496E74657276616C282866756E6374696F6E28297B6966286E2B2B2C2270726F67726573732D69732D636F6D706C657465223D3D692E72657065';
wwv_flow_api.g_varchar2_table(39) := '746974696F6E73297B6966287061727365496E7428617065782E6974656D2863292E67657456616C75652829293E3D3130302972657475726E20766F6964204D2850297D656C736520696628226E756D6265722D6F662D72657065746974696F6E73223D';
wwv_flow_api.g_varchar2_table(40) := '3D692E72657065746974696F6E732626743C3D6E2972657475726E20766F6964204D2850293B6E3E692E6C617374456E64496E74657276616C3F4D2850293A617065782E6974656D2863292E7265667265736828297D292C65297D3B692E61646454696D';
wwv_flow_api.g_varchar2_table(41) := '65722626692E6175746F5374617274496E74657276616C26265628293B6C6574204D3D66756E6374696F6E28297B636C656172496E74657276616C2850292C503D22222C617065782E6576656E742E74726967676572282223222B632C22666F735F7072';
wwv_flow_api.g_varchar2_table(42) := '625F696E74657276616C5F6F76657222297D7D7D7D28293B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(217662205100010043)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_file_name=>'js/script.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B2277696E646F77222C22464F53222C226974656D222C2270726F6772657373426172222C224D41585F56414C5545222C224556454E54';
wwv_flow_api.g_varchar2_table(2) := '5F434F4D504C455445222C2267657443616D656C43617365222C22776F7264222C226669727374436170222C2270617274222C22617272222C2273706C6974222C22726573756C74222C226C656E677468222C22746F557070657243617365222C227375';
wwv_flow_api.g_varchar2_table(3) := '62737472222C2269222C22737562737472696E67222C226765745368617065222C227368617065222C22676574436C73222C22706374222C226D7367222C22636F6D7075746556616C7565222C226974656D4E616D65222C2276616C7565222C2276616C';
wwv_flow_api.g_varchar2_table(4) := '75654E756D222C227061727365496E74222C22676574506374222C224D617468222C22726F756E64222C22696E6974222C22636F6E666967222C22696E69744A53222C227374726F6B655769647468222C22747261696C5769647468222C226D7367436F';
wwv_flow_api.g_varchar2_table(5) := '6C6F72222C226175746F5374617274496E74657276616C222C226C617374456E64496E74657276616C222C2246756E6374696F6E222C2263616C6C222C2274686973222C226D7367426F78222C22706374426F78222C226E616D65222C226974656D2422';
wwv_flow_api.g_varchar2_table(6) := '2C2224222C226974656D436F6E7461696E657224222C226974656D5772617070657224222C2270726253656C6563746F72222C22746172676574456C222C2266696E64222C22637265617465546172676574426F78222C22706F73222C2274797065222C';
wwv_flow_api.g_varchar2_table(7) := '22656C24222C2270726570656E64222C22617070656E64222C226D6572676556616C756573222C2270637456616C7565222C226D736756616C7565222C22636F6E7461696E6572222C2274657874222C2273686F77506374222C2273686F774D7367222C';
wwv_flow_api.g_varchar2_table(8) := '22686569676874222C22637373222C227072624F7074222C22656173696E67222C22616E696D6174696F6E222C226475726174696F6E222C22636F6C6F72222C22747261696C436F6C6F72222C227376675374796C65222C227769647468222C22737479';
wwv_flow_api.g_varchar2_table(9) := '6C65222C2266726F6D222C22746F222C22656E64436F6C6F72222C2273746570222C227374617465222C22626172222C2273657454657874222C2270617468222C22736574417474726962757465222C22636C6173734E616D65222C22616C69676E546F';
wwv_flow_api.g_varchar2_table(10) := '426F74746F6D222C226175746F5374796C65436F6E7461696E6572222C227061746873222C22707262222C2250726F6772657373426172222C22737461727456616C7565222C2270637456616C222C22736574222C226D7367456C222C226D736756616C';
wwv_flow_api.g_varchar2_table(11) := '222C22696E74657276616C222C227175657565222C2271756575497352756E6E696E67222C2272756E5175657565222C22616E696D617465222C22616E696D61746556616C7565222C226E657756616C7565222C2261706578222C226576656E74222C22';
wwv_flow_api.g_varchar2_table(12) := '74726967676572222C227368696674222C22637265617465222C2267657456616C7565222C2276616C222C2273657456616C7565222C22537472696E67222C226D756C746956616C7565222C2273657454696D656F7574222C22736C696365222C226A6F';
wwv_flow_api.g_varchar2_table(13) := '696E222C227175657565416E696D6174696F6E73222C2270757368222C226765744D657373616765222C227365744D657373616765222C22676574496E7374616E6365222C2272656672657368222C2273656C66222C22736572766572222C22706C7567';
wwv_flow_api.g_varchar2_table(14) := '696E222C22616A61784964222C22706167654974656D73222C226974656D73546F5375626D6974222C22726566726573684F626A656374222C22726566726573684F626A65637444617461222C22646F6E65222C2264617461222C227375636365737322';
wwv_flow_api.g_varchar2_table(15) := '2C2263616C6C6261636B73222C226661696C222C226A71584852222C2274657874537461747573222C226572726F725468726F776E222C226465627567222C226572726F72222C22616C77617973222C227374617274496E74657276616C222C22616464';
wwv_flow_api.g_varchar2_table(16) := '54696D6572222C22696E74657276616C5374617274222C22656E64496E74657276616C222C22636C656172496E74657276616C222C22696E666F222C22696E74657276616C53222C2272656672657368496E74657276616C222C226E756D4F6652657073';
wwv_flow_api.g_varchar2_table(17) := '222C22636F756E746572222C22736574496E74657276616C222C2272657065746974696F6E73225D2C226D617070696E6773223A2241414541412C4F41414F432C4941414D442C4F41414F432C4B41414F2C4741433342412C49414149432C4B41414F44';
wwv_flow_api.g_varchar2_table(18) := '2C49414149432C4D4141512C4741457642442C49414149432C4B41414B432C594141632C5741436E422C4D41414D432C454141592C49414B5A432C45414169422C344241694376422C4941755349432C454141652C53414155432C4541414D432C474141';
wwv_flow_api.g_varchar2_table(19) := '572C47414331432C49414349432C45414441432C4541414D482C4541414B492C4D41414D2C4B414358432C454141532C4741456E422C47414149462C45414149472C4F4141532C454143622C4F41414F442C454147504A2C49414341452C454141492C47';
wwv_flow_api.g_varchar2_table(20) := '41414B412C454141492C474141472C47414147492C63414167424A2C454141492C474141474B2C4F41414F2C49414772442C4941414B2C49414149432C454141492C45414147412C454141494E2C45414149472C4F414151472C4941433542502C454141';
wwv_flow_api.g_varchar2_table(21) := '4F432C454141494D2C47414350412C454141492C4941434A502C4541414F412C4541414B2C474141474B2C63414167424C2C4541414B512C554141552C4941456C444C2C47414155482C454145642C4F41414F472C474147504D2C454141572C53414155';
wwv_flow_api.g_varchar2_table(22) := '432C47414372422C4D4141612C55414154412C4541434F2C4F414541622C45414161612C4741414F2C4941492F42432C454141532C53414155432C4541414B432C47414378422C49414149562C4541554A2C4F415249412C4541444F2C63414150532C47';
wwv_flow_api.g_varchar2_table(23) := '414138422C63414150432C454143642C71424145452C6942414150442C454143532C77424145412C7742414756542C47414750572C454141652C53414155432C45414155432C4741436E432C49414149432C45414157432C53414153462C494141552C45';
wwv_flow_api.g_varchar2_table(24) := '41436C432C4F414149432C4741415974422C4541434C412C4541434173422C47413558472C454141412C45412B5848412C47414958452C454141532C534141554A2C45414155432C454141512C47414372432C494141494A2C4541414D4D2C5341415346';
wwv_flow_api.g_varchar2_table(25) := '2C494141552C45414149492C4B41414B432C4D4141632C494141524C2C47414165412C45414333442C4F41414F462C45414161432C45414155482C4941476C432C4D41414F2C43414348552C4B4170574F2C53414155432C45414151432C4741457A4244';
wwv_flow_api.g_varchar2_table(26) := '2C4541414F452C594141632C4741437242462C4541414F472C574141612C4741437042482C4541414F492C534141572C5541436C424A2C4541414F562C4941414D552C4541414F562C4B41414F2C6141433342552C4541414F4B2C6D4241416F422C4541';
wwv_flow_api.g_varchar2_table(27) := '4333424C2C4541414F4D2C674241416B422C47414572424C2C47414155412C6141416B424D2C55414335424E2C4541414F4F2C4B41414B432C4B41414D542C47414774422C49414D49552C45414151432C45414E526E422C45414157512C4541414F592C';
wwv_flow_api.g_varchar2_table(28) := '4B41436C42432C45414151432C454141452C4941414D74422C474143684275422C4541416942442C454141452C4941414D74422C454141572C634143704377422C45414165462C454141452C4941414D74422C454141572C5941436C4379422C45414163';
wwv_flow_api.g_varchar2_table(29) := '7A422C454141572C5741437A4230422C45414157482C45414165492C4B41414B2C734241472F42432C4541416B422C53414155432C4541414B432C4741436A432C49414149432C4541414D542C454141452C774241413042512C4541414F2C6942414D37';
wwv_flow_api.g_varchar2_table(30) := '432C4D414C572C6942414150442C45414341482C454141534D2C51414151442C474143482C6942414150462C47414350482C454141534F2C4F41414F462C47414562412C47414750472C454141632C53414155432C45414155432C4541415735422C4541';
wwv_flow_api.g_varchar2_table(31) := '414F562C4B414370442C4941414975432C45414159662C454141452C694241596C422C4F415849482C49414341412C4541414F6D422C4B41414B6C432C4541414F4A2C454141556D432C474141592C4B41436E422C6341416C4233422C4541414F2B422C';
wwv_flow_api.g_varchar2_table(32) := '53414350462C454141554A2C4F41414F642C4941497242442C47414134422C6341416C42562C4541414F67432C5341436A42482C454141554A2C4F41414F662C474147646D422C454141552C4941496A4237422C4541414F69432C51414132422C494141';
wwv_flow_api.g_varchar2_table(33) := '6A426A432C4541414F69432C51414378426A422C454141616B422C494141492C534141556C432C4541414F69432C51414974432C49414149452C454141532C434143546A432C59414161462C4541414F452C59414370426B432C4F41415139442C454141';
wwv_flow_api.g_varchar2_table(34) := '6130422C4541414F71432C5741433542432C5341415533432C534141534B2C4541414F73432C5541433142432C4D41414F76432C4541414F75432C4D414364432C5741415978432C4541414F77432C5741436E4272432C57414159482C4541414F472C57';
wwv_flow_api.g_varchar2_table(35) := '41436E4273432C534141552C4341434E432C4D41414F2C4F414350542C4F4141512C5341674468422C474133436F422C59414168426A432C4541414F32432C51414350522C4541414F532C4B41414F2C434141454C2C4D41414F76432C4541414F75432C';
wwv_flow_api.g_varchar2_table(36) := '4F414339424A2C4541414F552C4741414B2C434141454E2C4D41414F76432C4541414F38432C57414D6843582C4541414F592C4B41414F2C43414143432C4541414F432C4D41436274432C47414155442C4941416B432C6D424141684275432C45414149';
wwv_flow_api.g_varchar2_table(37) := '432C5341436A43442C45414149432C5141415178422C4541415975422C4541414978442C5541475A2C59414168424F2C4541414F32432C4F4143504D2C45414149452C4B41414B432C614141612C534141554A2C4541414D542C51414B78422C4D41416C';
wwv_flow_api.g_varchar2_table(38) := '4276432C4541414F2B422C5541435070422C45414153532C454141674270422C4541414F2B422C514141532C51414976422C4D41416C422F422C4541414F67432C5541435074422C45414153552C454141674270422C4541414F67432C514141532C5141';
wwv_flow_api.g_varchar2_table(39) := '4B76422C6341416C4268432C4541414F2B422C53414136432C6341416C422F422C4541414F67432C5541437A43472C4541414F4C2C4B41414F2C4341435672432C4D41414F69432C4541415931422C4541414F32422C5341415533422C4541414F562C4B';
wwv_flow_api.g_varchar2_table(40) := '414333432B442C554141576A452C4541414F592C4541414F2B422C514141532F422C4541414F67432C5341437A4373422C654141652C45414366432C6F4241416F422C45414370425A2C4D41414F2C434143484A2C4D41414F76432C4541414F492C5941';
wwv_flow_api.g_varchar2_table(41) := '4D4E2C55414168424A2C4541414F622C4D41416D422C43414331422C4941414971452C4541415178432C45414161472C4B41414B2C51414539422C47414441462C454141637A422C454141572C6341434C2C474141684267452C4541414D33452C4F4143';
wwv_flow_api.g_varchar2_table(42) := '4E2C4F41454A32452C45414173422C4741416842412C4541414D33452C4F4141632C454141492C4741414775452C614141612C4B41414D6E432C47414978442C4941414977432C4541414D2C49414149432C5941415978452C45414153632C4541414F62';
wwv_flow_api.g_varchar2_table(43) := '2C534141512C4941414D38422C454141616B422C4741456A442C55414168426E432C4541414F622C5141435073452C45414149502C514141552C5341415570422C4D414935422C4941414936422C4541416170452C45414161432C45414155512C454141';
wwv_flow_api.g_varchar2_table(44) := '4F34442C514141552C4941457A44482C45414149492C49414149462C474147522C49414149472C454141512F432C45414165492C4B41414B2C6F424143354232432C4541414D6A462C4F4141532C4741436669462C4541414D68432C4B41414B39422C45';
wwv_flow_api.g_varchar2_table(45) := '41414F2B442C514141552F442C4541414F562C4B414976432C49416B484930452C45416C4841432C454141512C47414352432C47414167422C45414570422C53414153432C4941434C442C47414167422C454143492C4741416842442C4541414D70462C';
wwv_flow_api.g_varchar2_table(46) := '4F41495634452C45414149572C51414151482C4541414D2C47414147492C634141632C57414533424A2C4541414D2C474141474B2C554141596C472C47414372426D472C4B41414B432C4D41414D432C514141512C4941414D6A462C454141556E422C47';
wwv_flow_api.g_varchar2_table(47) := '4147764334462C4541414D532C5141454E502C4F415841442C47414167422C4541674278424B2C4B41414B72472C4B41414B79472C4F41414F6E462C454141552C43414376426F462C534141552C5741434E2C4F41414F2F442C4541414D67452C4F4145';
wwv_flow_api.g_varchar2_table(48) := '6A42432C534141552C5341415572462C47414568422C4741414969422C49414134422C69424141566A422C4741417342412C614141694273462C514141532C4341436C452C49414149432C4541416176462C4541414D642C4D41414D2C4B41437A427147';
wwv_flow_api.g_varchar2_table(49) := '2C454141576E472C4F4141532C47414570426F472C594141572C574145506E422C4541414D68432C4B41414B6B442C45414157452C4D41414D2C47414147432C4B41414B2C51414372436E462C4541414F73432C5541476C422C4941414967432C454141';
wwv_flow_api.g_varchar2_table(50) := '572F452C45414161432C45414155432C47414374436F422C4541414D67452C49414149502C474145562C49414149442C45414165432C454141572C494143314274452C4541414F6F462C69424145506E422C4541414D6F422C4B41414B2C434141456842';
wwv_flow_api.g_varchar2_table(51) := '2C61414141412C45414163432C53414141412C49414574424A2C47414344432C4B41474A562C45414149572C51414151432C474141632C5741456C42432C474141596C472C4741435A6D472C4B41414B432C4D41414D432C514141512C4941414D6A462C';
wwv_flow_api.g_varchar2_table(52) := '454141556E422C4F414B6E4469482C574141592C574143522C4F41414935452C4541434F412C4541414F6F422C4F4145582C4941455879442C574141592C534141556A472C474143646F422C474143416F442C4541414D68432C4B41414B78432C494147';
wwv_flow_api.g_varchar2_table(53) := '6E426B472C594141612C574143542C4F41414F2F422C4741455867432C514141532C5741434C2C49414149432C4541414F6A462C4B41435037422C4541415332462C4B41414B6F422C4F41414F432C4F41414F35462C4541414F36462C4F4141512C4341';
wwv_flow_api.g_varchar2_table(54) := '433343432C5541415739462C4541414F2B462C6541436E422C43414343432C634141652C4941414D78472C454143724279472C6B4241416D426A472C494145764275452C4B41414B432C4D41414D432C514141512C4941414D6A462C45413150522C7942';
wwv_flow_api.g_varchar2_table(55) := '4130507743512C4741437A4470422C4541414F73482C4D41414B2C53414155432C47414364412C4541414B432C5541434C562C4541414B5A2C5341415371422C4541414B31472C4F4141532C474143784230472C4541414B37472C4B41454C32462C5941';
wwv_flow_api.g_varchar2_table(56) := '41572C57414348532C4541414B572C5541434C582C4541414B572C55414155642C57414157592C4541414B37472C4B41452F426F472C4541414B482C57414157592C4541414B37472C4F41453142552C4541414F73432C6341476E4267452C4D41414B2C';
wwv_flow_api.g_varchar2_table(57) := '53414155432C4541414F432C45414159432C4741436A436C432C4B41414B6D432C4D41414D432C4D41414D2C774341413043462C4D41433544472C5141414F2C5741434E72432C4B41414B432C4D41414D432C514141512C4941414D6A462C4541335162';
wwv_flow_api.g_varchar2_table(58) := '2C77424132513443512C4F4147684536472C634141652C5741435037472C4541414F38472C55414350432C4B414752432C594141612C5741434C68482C4541414F38472C57414350472C634141636A442C47414364412C454141572C4F414D76422C4941';
wwv_flow_api.g_varchar2_table(59) := '41492B432C45414167422C57414368422C474141492F432C454145412C594144414F2C4B41414B6D432C4D41414D512C4B41414B2C7744414770422C49414149432C4541415978482C534141534B2C4541414F6F482C694241433542432C454141593148';
wwv_flow_api.g_varchar2_table(60) := '2C534141534B2C4541414F71482C574141612C4741437A43432C454141552C4541436474442C4541415775442C614141592C5741456E422C47414441442C49414330422C77424141744274482C4541414F77482C614143502C4741414937482C53414153';
wwv_flow_api.g_varchar2_table(61) := '34452C4B41414B72472C4B41414B73422C474141556F462C614141652C49414535432C594144416F432C4541415968442C514147622C47414130422C79424141744268452C4541414F77482C61414356482C47414161432C454145622C594144414E2C45';
wwv_flow_api.g_varchar2_table(62) := '41415968442C47414B684273442C4541415574482C4541414F4D2C674241436A4230472C4541415968442C47414768424F2C4B41414B72472C4B41414B73422C4741415569472C594143724230422C494147486E482C4541414F38472C5541415939472C';
wwv_flow_api.g_varchar2_table(63) := '4541414F4B2C6D424143314230472C4941474A2C49414149432C454141632C57414364432C634141636A442C47414364412C454141572C474143584F2C4B41414B432C4D41414D432C514141512C4941414D6A462C454168554C2C3442415454222C2266';
wwv_flow_api.g_varchar2_table(64) := '696C65223A227363726970742E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(217662677466010046)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_file_name=>'js/script.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E666F732D7072622D636F6E7461696E65727B77696474683A313030253B70616464696E673A3570783B746578742D616C69676E3A63656E7465727D2E666F732D7072622D6D73672C2E666F732D7072622D6D73672D626F782C2E666F732D7072622D70';
wwv_flow_api.g_varchar2_table(2) := '63742D626F787B70616464696E673A30203570783B6D617267696E3A6175746F3B746578742D616C69676E3A63656E7465727D2E666F732D7072622D6F6E2D656C656D656E74202E666F732D7072622D6D73672D626F782C2E666F732D7072622D6F6E2D';
wwv_flow_api.g_varchar2_table(3) := '656C656D656E74202E666F732D7072622D7063742D626F787B6D617267696E3A756E7365743B646973706C61793A696E6C696E652D626C6F636B7D2E666F732D7072622D6D73677B70616464696E673A3020313070787D2E666F732D7072622D74657874';
wwv_flow_api.g_varchar2_table(4) := '7B646973706C61793A696E6C696E652D626C6F636B7D6469762E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D6C696E657B6865696768743A323470787D6469762E742D466F726D';
wwv_flow_api.g_varchar2_table(5) := '2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D6C696E657B6865696768743A323870787D6469762E742D466F726D2D6669';
wwv_flow_api.g_varchar2_table(6) := '656C64436F6E7461696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D6C696E657B6865696768743A333270787D6469762E742D466F726D2D6669656C';
wwv_flow_api.g_varchar2_table(7) := '64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D636972636C652C6469762E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D73656D692D63';
wwv_flow_api.g_varchar2_table(8) := '6972636C657B6865696768743A31303470787D6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D63';
wwv_flow_api.g_varchar2_table(9) := '6972636C657B6865696768743A31313270787D6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D';
wwv_flow_api.g_varchar2_table(10) := '636972636C657B6865696768743A31323070787D6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D';
wwv_flow_api.g_varchar2_table(11) := '73656D692D636972636C657B6865696768743A31313270787D6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F';
wwv_flow_api.g_varchar2_table(12) := '732D7072622D73656D692D636972636C657B6865696768743A31323070787D6469762E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D637573746F6D7B6865696768743A31303470';
wwv_flow_api.g_varchar2_table(13) := '783B77696474683A313030257D6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D637573746F6D7B';
wwv_flow_api.g_varchar2_table(14) := '6865696768743A31313270783B77696474683A313030257D6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F73';
wwv_flow_api.g_varchar2_table(15) := '2D7072622D637573746F6D7B6865696768743A31323070783B77696474683A313030257D2E666F732D7072622D777261707065722E666F732D7072622D637573746F6D207376677B77696474683A313030253B6865696768743A313030257D2E666F732D';
wwv_flow_api.g_varchar2_table(16) := '7072622D6F6E2D656C656D656E747B706F736974696F6E3A6162736F6C7574653B6C6566743A3530253B746F703A3530253B70616464696E673A303B6D617267696E3A303B7472616E73666F726D3A7472616E736C617465282D3530252C2D353025297D';
wwv_flow_api.g_varchar2_table(17) := '2E666F732D7072622D73656D692D636972636C65202E666F732D7072622D6F6E2D656C656D656E747B706F736974696F6E3A6162736F6C7574653B6C6566743A3530253B746F703A35302521696D706F7274616E743B70616464696E673A303B6D617267';
wwv_flow_api.g_varchar2_table(18) := '696E3A307D2E666F732D7072622D6C696E65202E666F732D7072622D61626F76652D656C656D656E747B706F736974696F6E3A6162736F6C7574653B6C6566743A3530253B746F703A303B70616464696E673A303B6D617267696E3A307D2E666F732D70';
wwv_flow_api.g_varchar2_table(19) := '72622D636972636C65202E666F732D7072622D61626F76652D656C656D656E742C2E666F732D7072622D73656D692D636972636C65202E666F732D7072622D61626F76652D656C656D656E747B706F736974696F6E3A6162736F6C7574653B6C6566743A';
wwv_flow_api.g_varchar2_table(20) := '3439253B746F703A303B70616464696E673A303B6D617267696E3A307D2E666F732D7072622D73656D692D636972636C65202E666F732D7072622D61626F76652D656C656D656E747B746F703A3021696D706F7274616E743B7472616E73666F726D3A75';
wwv_flow_api.g_varchar2_table(21) := '6E73657421696D706F7274616E747D2E666F732D7072622D62656C6F772D656C656D656E747B626F74746F6D3A303B70616464696E673A303B6D617267696E3A303B746578742D616C69676E3A63656E7465723B7472616E73666F726D3A756E73657421';
wwv_flow_api.g_varchar2_table(22) := '696D706F7274616E747D0A2F2A2320736F757263654D617070696E6755524C3D7374796C652E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(217668551085154719)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_file_name=>'css/style.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227374796C652E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C6B422C434143492C552C434143412C572C434143412C69422C4341654A2C592C43415A';
wwv_flow_api.g_varchar2_table(2) := '6B422C67422C4341416C422C67422C434143492C612C434143412C572C434143412C69422C4341496B432C6F432C43414174432C6F432C434143492C592C434143412C6F422C4341474A2C592C434143492C632C43414B4A2C612C434143492C6F422C43';
wwv_flow_api.g_varchar2_table(3) := '41494A2C75442C434143492C572C4341474A2C6F462C434143492C572C4341474A2C71462C434143492C572C4341494A2C79442C434161412C38442C43415A492C592C4341474A2C73462C434143492C592C4341474A2C75462C434143492C592C434151';
wwv_flow_api.g_varchar2_table(4) := '4A2C32462C434143492C592C4341474A2C34462C434143492C592C4341494A2C79442C434143492C592C434143412C552C4341474A2C73462C434143492C592C434143412C552C4341474A2C75462C434143492C592C434143412C552C4341474A2C6D43';
wwv_flow_api.g_varchar2_table(5) := '2C434143492C552C434143412C572C4341494A2C6D422C434143492C69422C434143412C512C434143412C4F2C434143412C532C434143412C512C434143412C38422C4341474A2C77432C434143492C69422C434143412C512C434143412C69422C4341';
wwv_flow_api.g_varchar2_table(6) := '43412C532C434143412C512C4341494A2C6F432C434143492C69422C434143412C512C434143412C4B2C434143412C532C434143412C512C4341474A2C73432C434151412C32432C434150492C69422C434143412C512C434143412C4B2C434143412C53';
wwv_flow_api.g_varchar2_table(7) := '2C434143412C512C4341474A2C32432C434147492C652C434147412C79422C4341494A2C73422C434143492C512C434143412C532C434143412C512C434143412C69422C434143412C7942222C2266696C65223A227374796C652E637373222C22736F75';
wwv_flow_api.g_varchar2_table(8) := '72636573436F6E74656E74223A5B222E666F732D7072622D636F6E7461696E6572207B5C6E2020202077696474683A20313030253B5C6E2020202070616464696E673A203570783B5C6E20202020746578742D616C69676E3A2063656E7465723B5C6E7D';
wwv_flow_api.g_varchar2_table(9) := '5C6E5C6E2E666F732D7072622D7063742D626F782C202E666F732D7072622D6D73672D626F78207B5C6E2020202070616464696E673A2030203570783B5C6E202020206D617267696E3A206175746F3B5C6E20202020746578742D616C69676E3A206365';
wwv_flow_api.g_varchar2_table(10) := '6E7465723B5C6E202020202F2A20646973706C61793A20626C6F636B3B202A2F5C6E7D5C6E5C6E2E666F732D7072622D6F6E2D656C656D656E74202E666F732D7072622D7063742D626F782C202E666F732D7072622D6F6E2D656C656D656E74202E666F';
wwv_flow_api.g_varchar2_table(11) := '732D7072622D6D73672D626F78207B5C6E202020206D617267696E3A20756E7365743B5C6E20202020646973706C61793A20696E6C696E652D626C6F636B3B5C6E7D5C6E5C6E2E666F732D7072622D6D7367207B5C6E2020202070616464696E673A2030';
wwv_flow_api.g_varchar2_table(12) := '20313070783B5C6E202020206D617267696E3A206175746F3B5C6E20202020746578742D616C69676E3A2063656E7465723B5C6E7D5C6E5C6E2E666F732D7072622D74657874207B5C6E20202020646973706C61793A20696E6C696E652D626C6F636B3B';
wwv_flow_api.g_varchar2_table(13) := '5C6E7D5C6E5C6E2F2A204C696E65202A2F5C6E6469762E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D6C696E6520207B5C6E202020206865696768743A20323470783B5C6E7D5C';
wwv_flow_api.g_varchar2_table(14) := '6E5C6E6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D6C696E6520207B5C6E2020202068656967';
wwv_flow_api.g_varchar2_table(15) := '68743A20323870783B5C6E7D5C6E5C6E6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D6C696E';
wwv_flow_api.g_varchar2_table(16) := '6520207B5C6E202020206865696768743A20333270783B5C6E7D5C6E5C6E2F2A20436972636C65202A2F5C6E6469762E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D636972636C';
wwv_flow_api.g_varchar2_table(17) := '65207B5C6E202020206865696768743A2031303470783B5C6E7D5C6E5C6E6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065';
wwv_flow_api.g_varchar2_table(18) := '722E666F732D7072622D636972636C65207B5C6E202020206865696768743A2031313270783B5C6E7D5C6E5C6E6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572';
wwv_flow_api.g_varchar2_table(19) := '202E666F732D7072622D777261707065722E666F732D7072622D636972636C65207B5C6E202020206865696768743A2031323070783B5C6E7D5C6E5C6E2F2A2053656D692D636972636C65202A2F5C6E6469762E742D466F726D2D6669656C64436F6E74';
wwv_flow_api.g_varchar2_table(20) := '61696E6572202E666F732D7072622D777261707065722E666F732D7072622D73656D692D636972636C65207B5C6E202020206865696768743A2031303470783B5C6E7D5C6E5C6E6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C61';
wwv_flow_api.g_varchar2_table(21) := '7267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D73656D692D636972636C65207B5C6E202020206865696768743A2031313270783B5C6E7D5C6E5C6E6469762E742D466F72';
wwv_flow_api.g_varchar2_table(22) := '6D2D6669656C64436F6E7461696E65722D2D786C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D73656D692D636972636C65207B5C6E202020206865696768743A2031';

wwv_flow_api.g_varchar2_table(23) := '323070783B5C6E7D5C6E5C6E2F2A20437573746F6D202A2F5C6E6469762E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D637573746F6D207B5C6E202020206865696768743A2031';
wwv_flow_api.g_varchar2_table(24) := '303470783B5C6E2020202077696474683A20313030253B5C6E7D5C6E5C6E6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D6C617267652E742D466F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065';
wwv_flow_api.g_varchar2_table(25) := '722E666F732D7072622D637573746F6D207B5C6E202020206865696768743A2031313270783B5C6E2020202077696474683A20313030253B5C6E7D5C6E5C6E6469762E742D466F726D2D6669656C64436F6E7461696E65722D2D786C617267652E742D46';
wwv_flow_api.g_varchar2_table(26) := '6F726D2D6669656C64436F6E7461696E6572202E666F732D7072622D777261707065722E666F732D7072622D637573746F6D207B5C6E202020206865696768743A2031323070783B5C6E2020202077696474683A20313030253B5C6E7D5C6E5C6E2E666F';
wwv_flow_api.g_varchar2_table(27) := '732D7072622D777261707065722E666F732D7072622D637573746F6D20737667207B5C6E2020202077696474683A20313030253B5C6E202020206865696768743A20313030253B5C6E7D5C6E5C6E2F2A206F6E2D656C656D656E74202A2F5C6E2E666F73';
wwv_flow_api.g_varchar2_table(28) := '2D7072622D6F6E2D656C656D656E74207B5C6E20202020706F736974696F6E3A206162736F6C7574653B5C6E202020206C6566743A203530253B5C6E20202020746F703A203530253B5C6E2020202070616464696E673A20303B5C6E202020206D617267';
wwv_flow_api.g_varchar2_table(29) := '696E3A20303B5C6E202020207472616E73666F726D3A207472616E736C617465282D3530252C202D353025295C6E7D5C6E5C6E2E666F732D7072622D73656D692D636972636C65202E666F732D7072622D6F6E2D656C656D656E74207B5C6E2020202070';
wwv_flow_api.g_varchar2_table(30) := '6F736974696F6E3A206162736F6C7574653B5C6E202020206C6566743A203530253B5C6E20202020746F703A2035302521696D706F7274616E743B5C6E2020202070616464696E673A20303B5C6E202020206D617267696E3A20303B5C6E7D5C6E5C6E2F';
wwv_flow_api.g_varchar2_table(31) := '2A2061626F76652D656C656D656E74202A2F5C6E2E666F732D7072622D6C696E65202E666F732D7072622D61626F76652D656C656D656E74207B5C6E20202020706F736974696F6E3A206162736F6C7574653B5C6E202020206C6566743A203530253B5C';
wwv_flow_api.g_varchar2_table(32) := '6E20202020746F703A20303B5C6E2020202070616464696E673A20303B5C6E202020206D617267696E3A20303B5C6E7D5C6E5C6E2E666F732D7072622D636972636C65202E666F732D7072622D61626F76652D656C656D656E74207B5C6E20202020706F';
wwv_flow_api.g_varchar2_table(33) := '736974696F6E3A206162736F6C7574653B5C6E202020206C6566743A203439253B5C6E20202020746F703A20303B5C6E2020202070616464696E673A20303B5C6E202020206D617267696E3A20303B5C6E7D5C6E5C6E2E666F732D7072622D73656D692D';
wwv_flow_api.g_varchar2_table(34) := '636972636C65202E666F732D7072622D61626F76652D656C656D656E74207B5C6E20202020706F736974696F6E3A206162736F6C7574653B5C6E202020206C6566743A203439253B5C6E20202020746F703A203021696D706F7274616E743B5C6E202020';
wwv_flow_api.g_varchar2_table(35) := '2070616464696E673A20303B5C6E202020206D617267696E3A20303B5C6E202020207472616E73666F726D3A20756E73657421696D706F7274616E743B5C6E7D5C6E5C6E2F2A2062656C6F772D656C656D656E74202A2F5C6E2E666F732D7072622D6265';
wwv_flow_api.g_varchar2_table(36) := '6C6F772D656C656D656E74207B5C6E20202020626F74746F6D3A20303B5C6E2020202070616464696E673A20303B5C6E202020206D617267696E3A20303B5C6E20202020746578742D616C69676E3A2063656E7465723B5C6E202020207472616E73666F';
wwv_flow_api.g_varchar2_table(37) := '726D3A20756E73657421696D706F7274616E743B5C6E7D5C6E225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(217668941644154722)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_file_name=>'css/style.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B2270726F67726573736261722E6D696E2E6A73225D2C226E616D6573223A5B2266222C226578706F727473222C226D6F64756C65222C22646566696E65222C22616D64222C2267222C227769';
wwv_flow_api.g_varchar2_table(2) := '6E646F77222C22676C6F62616C222C2273656C66222C2274686973222C2250726F6772657373426172222C2272222C2265222C226E222C2274222C226F222C2269222C2263222C2272657175697265222C2275222C2261222C224572726F72222C22636F';
wwv_flow_api.g_varchar2_table(3) := '6465222C2270222C2263616C6C222C226C656E677468222C2231222C22736869667479222C226C222C226D222C2264222C224F626A656374222C22646566696E6550726F7065727479222C22656E756D657261626C65222C22676574222C2253796D626F';
wwv_flow_api.g_varchar2_table(4) := '6C222C22746F537472696E67546167222C2276616C7565222C225F5F65734D6F64756C65222C22637265617465222C2262696E64222C2264656661756C74222C2270726F746F74797065222C226861734F776E50726F7065727479222C2273222C22636F';
wwv_flow_api.g_varchar2_table(5) := '6E666967757261626C65222C227772697461626C65222C226B6579222C226974657261746F72222C22636F6E7374727563746F72222C226B657973222C226765744F776E50726F706572747953796D626F6C73222C2266696C746572222C226765744F77';
wwv_flow_api.g_varchar2_table(6) := '6E50726F706572747944657363726970746F72222C2270757368222C226170706C79222C22617267756D656E7473222C22666F7245616368222C226765744F776E50726F706572747944657363726970746F7273222C22646566696E6550726F70657274';
wwv_flow_api.g_varchar2_table(7) := '696573222C2277222C2262222C22747765656E222C22747765656E61626C65222C2276222C225F222C2272657175657374416E696D6174696F6E4672616D65222C227765626B697452657175657374416E696D6174696F6E4672616D65222C226F526571';
wwv_flow_api.g_varchar2_table(8) := '75657374416E696D6174696F6E4672616D65222C226D7352657175657374416E696D6174696F6E4672616D65222C226D6F7A43616E63656C52657175657374416E696D6174696F6E4672616D65222C226D6F7A52657175657374416E696D6174696F6E46';
wwv_flow_api.g_varchar2_table(9) := '72616D65222C2273657454696D656F7574222C2268222C2279222C225F6174746163686D656E74222C225F63757272656E745374617465222C225F64656C6179222C225F656173696E67222C225F6F726967696E616C5374617465222C225F6475726174';
wwv_flow_api.g_varchar2_table(10) := '696F6E222C225F73746570222C225F7461726765745374617465222C225F74696D657374616D70222C2273746F70222C225F6170706C7946696C746572222C226E6F77222C225F6E657874222C225F70726576696F7573222C22547970654572726F7222';
wwv_flow_api.g_varchar2_table(11) := '2C225F636F6E66696775726564222C225F66696C74657273222C22736574436F6E666967222C226E657874222C22646F6E65222C2272657475726E222C225F706175736564417454696D65222C225F7374617274222C22726573756D65222C2261747461';
wwv_flow_api.g_varchar2_table(12) := '63686D656E74222C2264656C6179222C226475726174696F6E222C22656173696E67222C2266726F6D222C2270726F6D697365222C2250726F6D697365222C227374617274222C2273746570222C22746F222C225F6973506C6179696E67222C225F7363';
wwv_flow_api.g_varchar2_table(13) := '686564756C654964222C2266696C74657273222C224F222C22646F65734170706C79222C225F70726F6D697365222C225F7265736F6C7665222C225F72656A656374222C226361746368222C224D617468222C226D6178222C227365745363686564756C';
wwv_flow_api.g_varchar2_table(14) := '6546756E6374696F6E222C22666F726D756C6173222C2244617465222C2253222C226A222C224D222C226B222C2250222C2278222C2254222C2245222C2246222C2241222C2249222C2243222C2244222C2271222C2251222C22706F77222C22636F7322';
wwv_flow_api.g_varchar2_table(15) := '2C225049222C2273696E222C2273717274222C2246756E6374696F6E222C227061727365496E74222C225F746F6B656E44617461222C2242222C224172726179222C2269734172726179222C22746F537472696E67222C224E222C2252222C2256222C22';
wwv_flow_api.g_varchar2_table(16) := '736F75726365222C22526567457870222C22636F6E636174222C226D6170222C227265706C616365222C2273706C6974222C22737562737472222C226A6F696E222C226D61746368222C22666C6F6F72222C22666F726D6174537472696E67222C226368';
wwv_flow_api.g_varchar2_table(17) := '61724174222C22756E7368696674222C226368756E6B4E616D6573222C22746F4669786564222C22736F6D65222C22736574222C227A222C224C222C22616464222C22696E6465784F66222C2273706C696365222C22747765656E61626C6573222C2272';
wwv_flow_api.g_varchar2_table(18) := '656D6F7665222C226973506C6179696E67222C227061757365222C225765616B4D6170222C2257222C22646973706C61794E616D65222C227831222C227931222C227832222C227932222C2247222C22746F6B656E222C2232222C225368617065222C22';
wwv_flow_api.g_varchar2_table(19) := '7574696C73222C22436972636C65222C22636F6E7461696E6572222C226F7074696F6E73222C225F7061746854656D706C617465222C22636F6E7461696E6572417370656374526174696F222C225F70617468537472696E67222C226F707473222C2277';
wwv_flow_api.g_varchar2_table(20) := '696474684F665769646572222C227374726F6B655769647468222C22747261696C5769647468222C2272656E646572222C22726164697573222C2232726164697573222C225F747261696C537472696E67222C222E2F7368617065222C222E2F7574696C';
wwv_flow_api.g_varchar2_table(21) := '73222C2233222C224C696E65222C22766572746963616C222C225F696E697469616C697A65537667222C22737667222C2276696577426F78537472222C22736574417474726962757465222C2263656E746572222C2234222C2253656D69436972636C65';
wwv_flow_api.g_varchar2_table(22) := '222C22537175617265222C2250617468222C222E2F636972636C65222C222E2F6C696E65222C222E2F70617468222C222E2F73656D69636972636C65222C222E2F737175617265222C2235222C22547765656E61626C65222C22454153494E475F414C49';
wwv_flow_api.g_varchar2_table(23) := '41534553222C2265617365496E222C22656173654F7574222C2265617365496E4F7574222C2270617468222C22657874656E64222C22656C656D656E74222C226973537472696E67222C22646F63756D656E74222C22717565727953656C6563746F7222';
wwv_flow_api.g_varchar2_table(24) := '2C225F6F707473222C225F747765656E61626C65222C22676574546F74616C4C656E677468222C227374796C65222C227374726F6B65446173686172726179222C226F6666736574222C225F676574436F6D7075746564446173684F6666736574222C22';
wwv_flow_api.g_varchar2_table(25) := '70726F6772657373222C227061727365466C6F6174222C227374726F6B65446173686F6666736574222C225F70726F6772657373546F4F6666736574222C22697346756E6374696F6E222C225F63616C63756C617465546F222C227368617065222C225F';
wwv_flow_api.g_varchar2_table(26) := '73746F70547765656E222C22616E696D617465222C226362222C227061737365644F707473222C2264656661756C744F707473222C22736869667479456173696E67222C2276616C756573222C225F7265736F6C766546726F6D416E64546F222C226765';
wwv_flow_api.g_varchar2_table(27) := '74426F756E64696E67436C69656E7452656374222C226E65774F6666736574222C227374617465222C227265666572656E6365222C227468656E222C22657272222C22636F6E736F6C65222C226572726F72222C22636F6D70757465645374796C65222C';
wwv_flow_api.g_varchar2_table(28) := '22676574436F6D70757465645374796C65222C2267657450726F706572747956616C7565222C225F63616C63756C61746546726F6D222C22696E746572706F6C617465222C2236222C225F696E697469616C697A6554657874436F6E7461696E6572222C';
wwv_flow_api.g_varchar2_table(29) := '2274657874436F6E7461696E6572222C2274657874222C22746F70222C22626F74746F6D222C22616C69676E546F426F74746F6D222C227365745374796C65222C2237222C2244455354524F5945445F4552524F52222C22636F6C6F72222C2274726169';
wwv_flow_api.g_varchar2_table(30) := '6C436F6C6F72222C2266696C6C222C22706F736974696F6E222C226C656674222C2270616464696E67222C226D617267696E222C227472616E73666F726D222C22707265666978222C226175746F5374796C65436F6E7461696E6572222C22636C617373';
wwv_flow_api.g_varchar2_table(31) := '4E616D65222C227376675374796C65222C22646973706C6179222C227769647468222C227761726E696E6773222C2269734F626A656374222C22756E646566696E6564222C2273766756696577222C225F63726561746553766756696577222C225F636F';
wwv_flow_api.g_varchar2_table(32) := '6E7461696E6572222C22617070656E644368696C64222C225F7761726E436F6E7461696E6572417370656374526174696F222C227365745374796C6573222C22747261696C222C226E65774F707473222C225F70726F677265737350617468222C227365';
wwv_flow_api.g_varchar2_table(33) := '7454657874222C2264657374726F79222C22706172656E744E6F6465222C2272656D6F76654368696C64222C226E657754657874222C225F63726561746554657874436F6E7461696E6572222C2272656D6F76654368696C6472656E222C22696E6E6572';
wwv_flow_api.g_varchar2_table(34) := '48544D4C222C22637265617465456C656D656E744E53222C22747261696C50617468222C225F637265617465547261696C222C225F63726561746550617468222C2270617468537472696E67222C225F63726561746550617468456C656D656E74222C22';
wwv_flow_api.g_varchar2_table(35) := '637265617465456C656D656E74222C22746578745374796C65222C22686569676874222C22666C6F6174457175616C73222C227761726E222C226964222C2238222C225F747261696C54656D706C617465222C2268616C664F665374726F6B6557696474';
wwv_flow_api.g_varchar2_table(36) := '68222C2273746172744D617267696E222C2239222C2264657374696E6174696F6E222C22726563757273697665222C22617474724E616D65222C226465737456616C222C22736F7572636556616C222C2274656D706C617465222C2276617273222C2272';
wwv_flow_api.g_varchar2_table(37) := '656E6465726564222C2276616C222C22726567457870537472696E67222C22726567457870222C22656C5374796C65222C225052454649584553222C226361706974616C697A65222C227374796C6573222C22666F72456163684F626A656374222C2273';
wwv_flow_api.g_varchar2_table(38) := '74796C6556616C7565222C227374796C654E616D65222C22746F557070657243617365222C22736C696365222C226F626A222C22537472696E67222C226F626A656374222C2263616C6C6261636B222C22616273222C22464C4F41545F434F4D50415249';
wwv_flow_api.g_varchar2_table(39) := '534F4E5F455053494C4F4E222C22656C222C2266697273744368696C64225D2C226D617070696E6773223A22434141412C53414155412C474141472C4741416F422C6742414156432C5541416F432C6D42414154432C5141417342412C4F41414F442C51';
wwv_flow_api.g_varchar2_table(40) := '414151442C514141532C4941416D422C6B42414154472C5341417142412C4F41414F432C4941414B442C55414155482C4F41414F2C434141432C474141494B2C4541416B43412C474141622C6D42414154432C5141417742412C4F41412B422C6D424141';
wwv_flow_api.g_varchar2_table(41) := '54432C5141417742412C4F414136422C6D42414150432C4D41417342412C4B414159432C4B41414B4A2C454141454B2C59414163562C4D41414F2C574141572C47414149472C45414173422C4F41414F2C594141592C51414153512C47414145432C4541';
wwv_flow_api.g_varchar2_table(42) := '4145432C45414145432C474141472C51414153432C47414145432C4541414568422C474141472C49414149612C45414145472C474141472C434141432C494141494A2C45414145492C474141472C434141432C47414149432C474141452C6B4241416D42';
wwv_flow_api.g_varchar2_table(43) := '432C55414153412C4F4141512C4B4141496C422C4741414769422C454141452C4D41414F412C47414145442C474141452C454141492C49414147472C454141452C4D41414F412C47414145482C474141452C454141492C49414149492C474141452C4741';
wwv_flow_api.g_varchar2_table(44) := '4149432C4F41414D2C7542414175424C2C454141452C4941414B2C4D41414D492C47414145452C4B41414B2C6D4241416D42462C454141452C47414149472C47414145562C45414145472C49414149662C57414159572C47414145492C474141472C4741';
wwv_flow_api.g_varchar2_table(45) := '4147512C4B41414B442C4541414574422C514141512C53414153552C4741416F422C4D41414F492C4741416C42482C45414145492C474141472C474141474C2C49414165412C49414149592C45414145412C4541414574422C51414151552C4541414543';
wwv_flow_api.g_varchar2_table(46) := '2C45414145432C45414145432C474141472C4D41414F442C47414145472C47414147662C514141512C494141492C474141496B422C474141452C6B4241416D42442C55414153412C51414151462C454141452C45414145412C45414145462C4541414557';
wwv_flow_api.g_varchar2_table(47) := '2C4F41414F542C49414149442C45414145442C45414145452C474141492C4F41414F442C474141452C4D41414F4A2C4F41414F652C474141472C53414153522C4541415168422C4541414F442C4941453131422C53414153612C45414145442C47414147';
wwv_flow_api.g_varchar2_table(48) := '2C6742414169425A2C494141532C674241416942432C4741414F412C4541414F442C51414151592C494141492C6B4241416D42562C49414151412C4541414F432C49414149442C4541414F2C59414159552C474141472C6742414169425A2C4741415141';
wwv_flow_api.g_varchar2_table(49) := '2C4541415130422C4F41414F642C49414149432C45414145612C4F41414F642C4B41414B502C4F41414F2C574141592C4D41414F2C55414153512C474141592C51414153462C47414145442C474141472C47414147452C45414145462C474141472C4D41';
wwv_flow_api.g_varchar2_table(50) := '414F452C47414145462C47414147562C4F4141512C49414149652C47414145482C45414145462C494141494B2C454141454C2C4541414569422C474141452C4541414733422C574141592C4F41414F612C47414145482C47414147612C4B41414B522C45';
wwv_flow_api.g_varchar2_table(51) := '414145662C51414151652C45414145412C45414145662C51414151572C47414147492C45414145592C474141452C454141475A2C45414145662C51414176492C47414149592C4B414132492C4F41414F442C4741414569422C45414145662C4541414546';
wwv_flow_api.g_varchar2_table(52) := '2C454141454B2C454141454A2C45414145442C454141456B422C454141452C5341415368422C45414145442C45414145462C47414147432C45414145472C45414145442C45414145442C494141496B422C4F41414F432C654141656C422C45414145442C';
wwv_flow_api.g_varchar2_table(53) := '474141476F422C594141572C45414147432C4941414976422C4B41414B432C45414145442C454141452C53414153472C474141472C6D4241416F4271422C53414151412C4F41414F432C614141614C2C4F41414F432C654141656C422C4541414571422C';
wwv_flow_api.g_varchar2_table(54) := '4F41414F432C61414161432C4D41414D2C574141574E2C4F41414F432C654141656C422C454141452C6341416375422C4F41414D2C4B41414D7A422C45414145452C454141452C53414153412C45414145442C474141472C474141472C45414145412C49';
wwv_flow_api.g_varchar2_table(55) := '414149432C45414145462C45414145452C494141492C45414145442C454141452C4D41414F432C454141452C494141472C45414145442C474141472C674241416942432C49414147412C47414147412C4541414577422C574141572C4D41414F78422C45';
wwv_flow_api.g_varchar2_table(56) := '4141452C49414149482C474141456F422C4F41414F512C4F41414F2C4B41414D2C4941414733422C45414145442C45414145412C474141476F422C4F41414F432C6541416572422C454141452C5741415773422C594141572C45414147492C4D41414D76';
wwv_flow_api.g_varchar2_table(57) := '422C494141492C45414145442C474141472C674241416942432C474141452C494141492C47414149452C4B41414B462C47414145462C454141456B422C454141456E422C454141454B2C454141452C53414153482C474141472C4D41414F432C47414145';
wwv_flow_api.g_varchar2_table(58) := '442C4941414932422C4B41414B2C4B41414B78422C474141492C4F41414F4C2C49414147432C45414145432C454141452C53414153432C474141472C47414149442C47414145432C47414147412C4541414577422C574141572C574141572C4D41414F78';
wwv_flow_api.g_varchar2_table(59) := '422C4741414532422C534141532C574141572C4D41414F33422C474141472C4F41414F462C474141456B422C454141456A422C454141452C49414149412C47414147412C47414147442C45414145472C454141452C53414153442C45414145442C474141';
wwv_flow_api.g_varchar2_table(60) := '472C4D41414F6B422C5141414F572C55414155432C654141656E422C4B41414B562C45414145442C49414149442C45414145572C454141452C47414147582C45414145412C4541414567432C454141452C4B41414B2C5341415339422C45414145442C45';
wwv_flow_api.g_varchar2_table(61) := '414145442C474141472C634141612C53414155452C474141774C2C51414153452C47414145462C45414145442C474141472C494141492C47414149442C474141452C45414145412C45414145432C45414145592C4F41414F622C494141492C434141432C';
wwv_flow_api.g_varchar2_table(62) := '47414149442C47414145452C45414145442C45414147442C4741414573422C5741415774422C4541414573422C614141592C4541414774422C454141456B432C634141612C454141472C534141556C432C4B414149412C454141456D432C554141532C47';
wwv_flow_api.g_varchar2_table(63) := '414149662C4F41414F432C654141656C422C45414145482C454141456F432C4941414970432C494141492C51414153512C474141454C2C474141472C4F41414F4B2C454141452C6B4241416D4267422C534141512C674241416942412C5141414F612C53';
wwv_flow_api.g_varchar2_table(64) := '4141532C534141536C432C474141472C61414163412C494141472C53414153412C474141472C4D41414F412C494141472C6B4241416D4271422C5341415172422C454141456D432C63414163642C5141415172422C4941414971422C4F41414F4F2C5541';
wwv_flow_api.g_varchar2_table(65) := '41552C654141674235422C4B414149412C474141472C51414153432C47414145442C45414145442C474141472C47414149442C474141456D422C4F41414F6D422C4B41414B70432C454141472C4941414769422C4F41414F6F422C7342414173422C4341';
wwv_flow_api.g_varchar2_table(66) := '41432C4741414978432C474141456F422C4F41414F6F422C73424141734272432C45414147442C4B414149462C45414145412C4541414579432C4F41414F2C5341415576432C474141472C4D41414F6B422C5141414F73422C79424141794276432C4541';
wwv_flow_api.g_varchar2_table(67) := '4145442C474141476F422C6341416572422C4541414530432C4B41414B432C4D41414D33432C45414145442C474141472C4D41414F432C474141452C51414153512C474141454E2C474141472C494141492C47414149442C474141452C45414145412C45';
wwv_flow_api.g_varchar2_table(68) := '41414532432C554141552F422C4F41414F5A2C494141492C434141432C47414149442C474141452C4D41414D34432C5541415533432C4741414732432C5541415533432C4B41414D412C474141452C45414145452C4541414567422C4F41414F6E422C49';
wwv_flow_api.g_varchar2_table(69) := '4141472C4741414936432C514141512C5341415535432C47414147492C45414145482C45414145442C45414145442C45414145432C4D41414F6B422C4F41414F32422C30424141304233422C4F41414F34422C69424141694237432C4541414569422C4F';
wwv_flow_api.g_varchar2_table(70) := '41414F32422C30424141304239432C49414149472C4541414567422C4F41414F6E422C4941414936432C514141512C5341415535432C474141476B422C4F41414F432C654141656C422C45414145442C454141456B422C4F41414F73422C794241417942';
wwv_flow_api.g_varchar2_table(71) := '7A432C45414145432C4D41414F2C4D41414F432C474141452C51414153472C47414145482C45414145442C45414145442C474141472C4D41414F432C4B41414B432C4741414569422C4F41414F432C654141656C422C45414145442C4741414777422C4D';
wwv_flow_api.g_varchar2_table(72) := '41414D7A422C4541414571422C594141572C45414147592C634141612C45414147432C554141532C4941414B68432C45414145442C47414147442C45414145452C4541417578492C5141415338432C4B4141492C4741414939432C4741414530432C5541';
wwv_flow_api.g_varchar2_table(73) := '41552F422C4F41414F2C4F4141472C4B4141532B422C554141552C47414147412C554141552C4D41414D33432C454141452C4741414967442C474141456A442C45414145432C4541414569442C4D41414D68442C454141472C4F41414F462C474141456D';
wwv_flow_api.g_varchar2_table(74) := '442C554141556C442C45414145442C4541416E6F4C412C454141456B422C454141456A422C454141452C494141492C574141592C4D41414F6D442C4B41414B70442C454141456B422C454141456A422C454141452C494141492C574141592C4D41414F6F';
wwv_flow_api.g_varchar2_table(75) := '442C4B41414B72442C454141456B422C454141456A422C454141452C494141492C574141592C4D41414F67422C4B41414B6A422C454141456B422C454141456A422C454141452C494141492C574141592C4D41414F67442C4B41414B6A442C454141456B';
wwv_flow_api.g_varchar2_table(76) := '422C454141456A422C454141452C494141492C574141592C4D41414F2B432C4941414B2C494141496A442C47414145432C454141452C474141796B435A2C454141452C6D4241416F424D2C5141414F412C4F41414F512C4541414538422C454141453543';
wwv_flow_api.g_varchar2_table(77) := '2C454141456B452C7542414175426C452C454141456D452C3642414136426E452C454141456F452C77424141774270452C4541414571452C79424141794272452C4541414573452C67434141674374452C4541414575452C304241413042432C57414157';
wwv_flow_api.g_varchar2_table(78) := '35432C454141452C6141416136432C454141452C4B41414B6C442C454141452C4B41414B4F2C45414145562C4B41414B542C4741414771442C454141452C534141536C442C45414145442C45414145442C45414145442C454141454B2C45414145472C45';
wwv_flow_api.g_varchar2_table(79) := '4141454A2C474141472C474141494B2C474141454E2C454141454B2C454141452C474141474C2C454141454B2C47414147482C434141452C4B4141492C47414149432C4B41414B4A2C474141452C434141432C47414149622C47414145652C4541414545';
wwv_flow_api.g_varchar2_table(80) := '2C4741414732422C4541414535432C4541414577422C4B41414B78422C4541414538422C4541414539422C4741414734422C4541414568422C454141454B2C454141474A2C47414145492C47414147572C474141476A422C454141454D2C47414147572C';
wwv_flow_api.g_varchar2_table(81) := '4741414767422C4541414578422C474141472C4D41414F502C4941414736442C454141452C5341415335442C45414145442C474141472C47414149442C47414145452C4541414536442C5941415968452C45414145472C4541414538442C634141633544';
wwv_flow_api.g_varchar2_table(82) := '2C45414145462C454141452B442C4F41414F31442C454141454C2C4541414567452C514141512F442C45414145442C4541414569452C6541416533442C454141454E2C454141456B452C554141552F442C45414145482C454141456D452C4D41414D6A46';
wwv_flow_api.g_varchar2_table(83) := '2C45414145632C454141456F452C6141416174432C4541414539422C4541414571452C5741415776442C4541414567422C4541414535422C45414145492C4541414571442C4541414535442C45414145652C45414145412C45414145662C45414145552C';
wwv_flow_api.g_varchar2_table(84) := '45414145482C47414147512C4541414536432C45414147412C4941414737432C47414147582C454141456A422C45414145592C45414145572C47414147542C4541414573452C4D41414B2C4B41414D74452C4541414575452C614141612C654141655A2C';
wwv_flow_api.g_varchar2_table(85) := '4541414537422C4541414535422C4741414779442C454141452C4541414572442C454141452C4541414577422C454141452C47414147412C4741414735422C4541414567442C45414145532C4541414539442C45414145492C45414145662C454141456F';
wwv_flow_api.g_varchar2_table(86) := '422C4541414577422C454141457A422C474141474C2C4541414575452C614141612C6341416370452C454141454E2C45414145432C45414145572C4B41414B30432C454141452C574141572C494141492C474141496E442C474141452B432C4541414579';
wwv_flow_api.g_varchar2_table(87) := '422C4D41414D7A452C4541414534442C4541414535442C474141472C434141432C47414149442C47414145432C4541414530452C4B41414D622C4741414537442C45414145432C47414147442C45414145442C4941414969422C454141452C5341415366';
wwv_flow_api.g_varchar2_table(88) := '2C474141472C47414149442C4741414532432C554141552F422C4F41414F2C4F4141472C4B4141532B422C554141552C47414147412C554141552C474141472C5341415335432C4B41414B442C45414145512C454141454E2C454141472C494141472C57';
wwv_flow_api.g_varchar2_table(89) := '414157462C474141472C61414161412C454141452C494141492C474141494B2C4B41414B462C47414145462C45414145492C47414147482C4D41414F2C4B4141492C47414149452C4B41414B442C47414145462C45414145472C47414147462C45414145';
wwv_flow_api.g_varchar2_table(90) := '452C494141492C514141532C4F41414F482C49414147502C454141452C53414153532C474141472C47414147412C4941414932442C47414147412C4541414533442C4541414579452C4F41414F642C45414145652C554141552C4B41414B6A452C454141';
wwv_flow_api.g_varchar2_table(91) := '452C534141552C49414147542C49414149532C47414147412C45414145542C4541414530452C574141576A452C4541414567452C4D41414D2C4B41414B642C454141452C534141532C434141432C4741414935442C47414145432C4541414530452C5541';
wwv_flow_api.g_varchar2_table(92) := '415535452C45414145452C4541414579452C4B41414D31452C4741414530452C4D41414D33452C45414145412C4541414534452C5541415533452C45414145432C4541414530452C5541415531452C4541414579452C4D41414D2C4D41414D31422C4541';
wwv_flow_api.g_varchar2_table(93) := '41452C574141572C514141532F432C4B4141492C47414149442C4741414532432C554141552F422C4F41414F2C4F4141472C4B4141532B422C554141552C47414147412C554141552C4D41414D35432C4541414534432C554141552F422C4F41414F2C4F';
wwv_flow_api.g_varchar2_table(94) := '4141472C4B4141532B422C554141552C47414147412C554141552C4F4141472C494141512C5341415331432C45414145442C474141472C4B41414B432C59414161442C494141472C4B41414D2C4941414934452C574141552C73434141734368462C4B41';
wwv_flow_api.g_varchar2_table(95) := '414B4B2C474141474C2C4B41414B6D452C634141632F442C454141454A2C4B41414B69462C614141592C454141476A462C4B41414B6B462C594141596C462C4B41414B30452C574141572C4B41414B31452C4B41414B38452C4D41414D2C4B41414B3945';
wwv_flow_api.g_varchar2_table(96) := '2C4B41414B2B452C554141552C4B41414B35452C47414147482C4B41414B6D462C5541415568462C474141472C47414149432C47414145442C45414145442C434141452C4F41414F452C47414145432C47414147462C494141496D432C494141492C6541';
wwv_flow_api.g_varchar2_table(97) := '4165562C4D41414D2C5341415376422C474141472C47414149442C494141452C45414147442C474141452C45414147442C4D4141452C4541414F2C4B4141492C494141492C474141494B2C47414145472C45414145562C4B41414B6B462C534141537844';
wwv_flow_api.g_varchar2_table(98) := '2C4F41414F612C634141636E432C47414147472C45414145472C4541414530452C51414151432C4D41414D6A462C474141452C454141472C434141432C47414149452C47414145432C4541414571422C4D41414D76422C45414147432C49414147412C45';
wwv_flow_api.g_varchar2_table(99) := '4141454E2C4F41414F2C4D41414D4B2C47414147462C474141452C45414147442C45414145472C454141452C514141512C49414149442C474141472C4D41414D4D2C4541414534452C5141415135452C4541414534452C534141532C514141512C474141';
wwv_flow_api.g_varchar2_table(100) := '476E462C454141452C4B41414D442C5141414F6F432C494141492C51414151562C4D41414D2C574141572C4741414978422C4741414532432C554141552F422C4F41414F2C4F4141472C4B4141532B422C554141552C47414147412C554141552C4F4141';
wwv_flow_api.g_varchar2_table(101) := '472C4741414F35432C45414145482C4B41414B6B452C5941415968452C45414145462C4B41414B69462C574141592C5141414F37452C47414147462C47414147462C4B41414B6D462C554141552F452C474141474A2C4B41414B75462C634141632C4B41';
wwv_flow_api.g_varchar2_table(102) := '414B76462C4B41414B30452C5741415772452C4541414577452C4D41414D37452C4B41414B77462C4F41414F78462C4B41414B79422C4D41414D74422C47414147482C4B41414B79462C594141596E442C494141492C59414159562C4D41414D2C574141';
wwv_flow_api.g_varchar2_table(103) := '572C4741414978422C474141454A2C4B41414B472C4541414534432C554141552F422C4F41414F2C4F4141472C4B4141532B422C554141552C47414147412C554141552C4D41414D37432C45414145432C4541414575462C574141576E462C454141454A';
wwv_flow_api.g_varchar2_table(104) := '2C4541414577462C4D41414D6A462C4D4141452C4B414153482C454141452C45414145412C45414145442C45414145482C4541414579462C5341415370462C4D4141452C4B414153462C454141452C49414149412C45414145662C45414145592C454141';
wwv_flow_api.g_varchar2_table(105) := '4530462C4F41414F31442C4541414568432C4541414532462C4B41414B39422C4541414537442C4541414534462C514141516A462C4D4141452C4B4141536B442C4541414567432C5141415168432C4541414533432C454141456C422C4541414538462C';
wwv_flow_api.g_varchar2_table(106) := '4D41414D31432C4D4141452C4B4141536C432C45414145462C45414145452C4541414534432C4541414539442C454141452B462C4B41414B31432C4D4141452C4B414153532C4541414539432C4541414538432C4541414572452C454141454F2C454141';
wwv_flow_api.g_varchar2_table(107) := '4567472C454141476E472C4D41414B69462C614141592C454141476A462C4B41414B6B452C5941415968452C45414145462C4B41414B6F472C594141572C4541414770472C4B41414B75462C634141632C4B41414B76462C4B41414B71472C594141592C';
wwv_flow_api.g_varchar2_table(108) := '4B41414B72472C4B41414B6F452C4F41414F31442C45414145562C4B41414B77462C4F41414F6A432C4541414576442C4B41414B77452C4D41414D68422C4541414578442C4B41414B75452C554141552F442C45414145522C4B41414B6D452C63414163';

wwv_flow_api.g_varchar2_table(109) := '78442C4B41414B77422C474141476E432C4B41414B79422C4F41414F7A422C4B41414B73452C6541416574452C4B41414B79422C4D41414D7A422C4B41414B79452C6141416139442C4B41414B662C47414147492C4B41414B79422C4D41414F2C494141';
wwv_flow_api.g_varchar2_table(110) := '4932422C4741414570442C4B41414B6D452C614141636E452C4D41414B79452C6141416139442C4B41414B79432C4B41414B70442C4B41414B79452C634141637A452C4B41414B71452C514141516A442C4541414567432C4541414537442C454141472C';
wwv_flow_api.g_varchar2_table(111) := '4941414934442C4741414539432C4541414569472C4F4141512C4B4141492C47414149432C4B41414B76472C4D41414B6B462C534141536C452C4F41414F2C454141456D432C45414145412C454141456F442C47414147432C5541415578472C4F41414F';
wwv_flow_api.g_varchar2_table(112) := '412C4B41414B6B462C5341415372432C4B41414B4D2C454141456F442C474141492C4F41414F76472C4D41414B34452C614141612C67424141674235452C4B41414B79472C534141532C4741414933462C474141452C53414155542C45414145462C4741';
wwv_flow_api.g_varchar2_table(113) := '4147432C4541414573472C5341415372472C45414145442C4541414575472C5141415178472C4941414B482C4B41414B79472C53414153472C4D41414D7A462C474141476E422C5141415173432C494141492C4D41414D562C4D41414D2C574141572C4D';
wwv_flow_api.g_varchar2_table(114) := '41414F6A422C4D41414B582C4B41414B6D452C6B4241416B4237422C494141492C4D41414D562C4D41414D2C5341415376422C474141474C2C4B41414B6D452C6341416339442C4B41414B69432C494141492C51414151562C4D41414D2C574141572C47';
wwv_flow_api.g_varchar2_table(115) := '41414735422C4B41414B6F472C574141572C4D41414F70472C4D41414B75462C634141636C462C4541414577452C4D41414D37452C4B41414B6F472C594141572C4541414778472C45414145492C4D41414D412C5141415173432C494141492C53414153';
wwv_flow_api.g_varchar2_table(116) := '562C4D41414D2C574141572C474141472C4F41414F35422C4B41414B30452C574141572C4D41414F31452C4D41414B71442C4F4141512C4941414772442C4B41414B6F472C574141572C4D41414F70472C4D41414B79472C514141532C4941414972472C';
wwv_flow_api.g_varchar2_table(117) := '47414145432C4541414577452C4B41414D2C4F41414F37452C4D41414B75462C67424141674276462C4B41414B30452C5941415974452C454141454A2C4B41414B75462C6341416376462C4B41414B75462C634141632C4D41414D76462C4B41414B6F47';
wwv_flow_api.g_varchar2_table(118) := '2C594141572C454141472C4F41414F70432C47414147412C4541414568452C4B41414B632C45414145642C4B41414B2C514141534B2C4B41414932442C4941414937422C4541414570422C4B41414B78422C45414145632C454141452C494141492C4941';
wwv_flow_api.g_varchar2_table(119) := '41496D442C5541415578442C4B41414B2B452C554141556A452C45414145412C4541414567452C4D41414D39452C4B41414B632C45414145642C4D41414D412C4B41414B79472C594141596E452C494141492C4F41414F562C4D41414D2C534141537842';
wwv_flow_api.g_varchar2_table(120) := '2C47414147412C4541414579472C4B41414B432C4941414931472C454141452C454141472C49414149442C47414145452C4541414577452C4B41414D2C4F41414F37452C4D41414B30452C5741415774452C494141492C454141454A2C4D41414D412C4B';
wwv_flow_api.g_varchar2_table(121) := '41414B30452C5741415776452C45414145432C454141454A2C4B41414B6F472C594141596E432C454141456A452C4B41414B472C47414147482C5341415373432C494141492C4F41414F562C4D41414D2C574141572C4741414976422C4741414530432C';
wwv_flow_api.g_varchar2_table(122) := '554141552F422C4F41414F2C4F4141472C4B4141532B422C554141552C49414149412C554141552C4741414733432C454141454A2C4B41414B6B452C594141592F442C45414145482C4B41414B6D452C634141636A452C45414145462C4B41414B71452C';
wwv_flow_api.g_varchar2_table(123) := '5141415139442C45414145502C4B41414B73452C6541416535442C45414145562C4B41414B79452C594141612C494141477A452C4B41414B6F472C574141572C4D41414F70472C4D41414B6F472C594141572C4541414778472C45414145492C4D41414D';
wwv_flow_api.g_varchar2_table(124) := '4B2C474141474C2C4B41414B34452C614141612C6541416572422C454141452C4541414570442C45414145492C45414145472C454141452C454141452C45414145522C47414147462C4B41414B34452C614141612C6341416335452C4B41414B34452C61';
wwv_flow_api.g_varchar2_table(125) := '4141612C69424141694235452C4B41414B30472C5341415376472C45414145432C494141494A2C4B41414B32472C5141415178472C45414145432C474141474A2C5141415173432C494141492C59414159562C4D41414D2C574141572C4D41414F35422C';
wwv_flow_api.g_varchar2_table(126) := '4D41414B6F472C6341416339442C494141492C734241417342562C4D41414D2C5341415378422C47414147432C4541414530472C6F4241416F4233472C4D41414D6B432C494141492C55414155562C4D41414D2C574141572C494141492C474141497642';
wwv_flow_api.g_varchar2_table(127) := '2C4B41414B4C2C59414159412C4D41414B4B2C51414151452C45414145482C4541414536422C5541415539422C47414147442C474141474B2C45414145482C45414145462C47414147472C49414138482B432C4741414532442C6F4241416F422C534141';
wwv_flow_api.g_varchar2_table(128) := '5331472C474141472C4D41414F38422C4741414539422C474141472B432C4541414534442C5341415333462C454141452B422C454141456B442C574141576C442C4541414579422C494141496F432C4B41414B70432C4B41414B2C574141572C4F41414F';
wwv_flow_api.g_varchar2_table(129) := '2C474141496F432C534141516C472C4B41414B662C4B41414B472C454141452C4B41414B2C53414153452C45414145442C45414145442C474141472C59414161412C47414145442C45414145452C47414147442C454141456B422C454141456A422C4541';
wwv_flow_api.g_varchar2_table(130) := '41452C534141532C574141592C4D41414F462C4B41414B432C454141456B422C454141456A422C454141452C614141612C574141592C4D41414F472C4B41414B4A2C454141456B422C454141456A422C454141452C634141632C574141592C4D41414F4D';
wwv_flow_api.g_varchar2_table(131) := '2C4B41414B502C454141456B422C454141456A422C454141452C6742414167422C574141592C4D41414F452C4B41414B482C454141456B422C454141456A422C454141452C634141632C574141592C4D41414F4F2C4B41414B522C454141456B422C4541';
wwv_flow_api.g_varchar2_table(132) := '41456A422C454141452C654141652C574141592C4D41414F492C4B41414B4C2C454141456B422C454141456A422C454141452C6942414169422C574141592C4D41414F622C4B41414B592C454141456B422C454141456A422C454141452C634141632C57';
wwv_flow_api.g_varchar2_table(133) := '4141592C4D41414F2B422C4B41414B68432C454141456B422C454141456A422C454141452C654141652C574141592C4D41414F652C4B41414B68422C454141456B422C454141456A422C454141452C6942414169422C574141592C4D41414F34442C4B41';
wwv_flow_api.g_varchar2_table(134) := '414B37442C454141456B422C454141456A422C454141452C634141632C574141592C4D41414F552C4B41414B582C454141456B422C454141456A422C454141452C654141652C574141592C4D41414F69422C4B41414B6C422C454141456B422C45414145';
wwv_flow_api.g_varchar2_table(135) := '6A422C454141452C6942414169422C574141592C4D41414F6D442C4B41414B70442C454141456B422C454141456A422C454141452C614141612C574141592C4D41414F36442C4B41414B39442C454141456B422C454141456A422C454141452C63414163';
wwv_flow_api.g_varchar2_table(136) := '2C574141592C4D41414F6F442C4B41414B72442C454141456B422C454141456A422C454141452C6742414167422C574141592C4D41414F67422C4B41414B6A422C454141456B422C454141456A422C454141452C614141612C574141592C4D41414F522C';
wwv_flow_api.g_varchar2_table(137) := '4B41414B4F2C454141456B422C454141456A422C454141452C634141632C574141592C4D41414F67442C4B41414B6A442C454141456B422C454141456A422C454141452C6742414167422C574141592C4D41414F2B432C4B41414B68442C454141456B42';
wwv_flow_api.g_varchar2_table(138) := '2C454141456A422C454141452C614141612C574141592C4D41414F6D472C4B41414B70472C454141456B422C454141456A422C454141452C634141632C574141592C4D41414F38472C4B41414B2F472C454141456B422C454141456A422C454141452C67';
wwv_flow_api.g_varchar2_table(139) := '42414167422C574141592C4D41414F2B472C4B41414B68482C454141456B422C454141456A422C454141452C6742414167422C574141592C4D41414F67482C4B41414B6A482C454141456B422C454141456A422C454141452C614141612C574141592C4D';
wwv_flow_api.g_varchar2_table(140) := '41414F69482C4B41414B6C482C454141456B422C454141456A422C454141452C634141632C574141592C4D41414F6B482C4B41414B6E482C454141456B422C454141456A422C454141452C6742414167422C574141592C4D41414F6D482C4B41414B7048';
wwv_flow_api.g_varchar2_table(141) := '2C454141456B422C454141456A422C454141452C554141552C574141592C4D41414F6F482C4B41414B72482C454141456B422C454141456A422C454141452C634141632C574141592C4D41414F71482C4B41414B74482C454141456B422C454141456A42';
wwv_flow_api.g_varchar2_table(142) := '2C454141452C594141592C574141592C4D41414F73482C4B41414B76482C454141456B422C454141456A422C454141452C554141552C574141592C4D41414F75482C4B41414B78482C454141456B422C454141456A422C454141452C534141532C574141';
wwv_flow_api.g_varchar2_table(143) := '592C4D41414F77482C4B41414B7A482C454141456B422C454141456A422C454141452C614141612C574141592C4D41414F79482C4B41414B31482C454141456B422C454141456A422C454141452C614141612C574141592C4D41414F30482C4B41414B33';
wwv_flow_api.g_varchar2_table(144) := '482C454141456B422C454141456A422C454141452C574141572C574141592C4D41414F32482C4B41414B35482C454141456B422C454141456A422C454141452C534141532C574141592C4D41414F34482C4941637838512C4941414939482C474141452C';
wwv_flow_api.g_varchar2_table(145) := '53414153472C474141472C4D41414F412C49414147452C454141452C53414153462C474141472C4D41414F77472C4D41414B6F422C4941414935482C454141452C494141494B2C454141452C534141534C2C474141472C5141415177472C4B41414B6F42';
wwv_flow_api.g_varchar2_table(146) := '2C4941414935482C454141452C454141452C474141472C49414149432C454141452C53414153442C474141472C4F41414F412C474141472C494141492C454141452C4741414777472C4B41414B6F422C4941414935482C454141452C494141492C4B4141';
wwv_flow_api.g_varchar2_table(147) := '4B412C474141472C47414147412C454141452C494141494D2C454141452C534141534E2C474141472C4D41414F77472C4D41414B6F422C4941414935482C454141452C49414149472C454141452C53414153482C474141472C4D41414F77472C4D41414B';
wwv_flow_api.g_varchar2_table(148) := '6F422C4941414935482C454141452C454141452C474141472C47414147642C454141452C53414153632C474141472C4F41414F412C474141472C494141492C454141452C4741414777472C4B41414B6F422C4941414935482C454141452C474141472C49';
wwv_flow_api.g_varchar2_table(149) := '41414977472C4B41414B6F422C4941414935482C454141452C454141452C474141472C4941414938422C454141452C5341415339422C474141472C4D41414F77472C4D41414B6F422C4941414935482C454141452C49414149632C454141452C53414153';
wwv_flow_api.g_varchar2_table(150) := '642C474141472C5141415177472C4B41414B6F422C4941414935482C454141452C454141452C474141472C4941414932442C454141452C5341415333442C474141472C4F41414F412C474141472C494141492C454141452C4741414777472C4B41414B6F';
wwv_flow_api.g_varchar2_table(151) := '422C4941414935482C454141452C494141492C4B41414B412C474141472C4741414777472C4B41414B6F422C4941414935482C454141452C474141472C49414149532C454141452C53414153542C474141472C4D41414F77472C4D41414B6F422C494141';
wwv_flow_api.g_varchar2_table(152) := '4935482C454141452C4941414967422C454141452C5341415368422C474141472C4D41414F77472C4D41414B6F422C4941414935482C454141452C454141452C474141472C474141476B442C454141452C534141536C442C474141472C4F41414F412C47';
wwv_flow_api.g_varchar2_table(153) := '4141472C494141492C454141452C4741414777472C4B41414B6F422C4941414935482C454141452C474141472C4941414977472C4B41414B6F422C4941414935482C454141452C454141452C474141472C4941414934442C454141452C5341415335442C';
wwv_flow_api.g_varchar2_table(154) := '474141472C4D41414F2C4741414577472C4B41414B71422C4941414937482C4741414777472C4B41414B73422C474141472C4B41414B33452C454141452C534141536E442C474141472C4D41414F77472C4D41414B75422C494141492F482C4741414777';
wwv_flow_api.g_varchar2_table(155) := '472C4B41414B73422C474141472C4B41414B2F472C454141452C53414153662C474141472C4F41414F2C4941414977472C4B41414B71422C4941414972422C4B41414B73422C4741414739482C474141472C49414149542C454141452C53414153532C47';
wwv_flow_api.g_varchar2_table(156) := '4141472C4D41414F2C4B414149412C454141452C4541414577472C4B41414B6F422C494141492C454141452C4941414935482C454141452C4B41414B2B432C454141452C534141532F432C474141472C4D41414F2C4B414149412C454141452C45414145';
wwv_flow_api.g_varchar2_table(157) := '2C4541414577472C4B41414B6F422C494141492C474141472C4741414735482C4941414938432C454141452C5341415339432C474141472C4D41414F2C4B414149412C454141452C454141452C49414149412C454141452C47414147412C474141472C49';
wwv_flow_api.g_varchar2_table(158) := '4141492C454141452C4741414777472C4B41414B6F422C494141492C454141452C4941414935482C454141452C494141492C494141492C4541414577472C4B41414B6F422C494141492C474141472C4B41414B35482C4B41414B6B472C454141452C5341';
wwv_flow_api.g_varchar2_table(159) := '41536C472C474141472C5141415177472C4B41414B77422C4B41414B2C4541414568492C45414145412C474141472C4941414936472C454141452C5341415337472C474141472C4D41414F77472C4D41414B77422C4B41414B2C4541414578422C4B4141';
wwv_flow_api.g_varchar2_table(160) := '4B6F422C4941414935482C454141452C454141452C4B41414B38472C454141452C5341415339472C474141472C4F41414F412C474141472C494141492C474141472C4941414977472C4B41414B77422C4B41414B2C4541414568492C45414145412C4741';
wwv_flow_api.g_varchar2_table(161) := '41472C474141472C4941414977472C4B41414B77422C4B41414B2C4741414768492C474141472C47414147412C474141472C494141492B472C454141452C534141532F472C474141472C4D41414F412C474141452C454141452C4B41414B2C4F41414F41';
wwv_flow_api.g_varchar2_table(162) := '2C45414145412C45414145412C454141452C454141452C4B41414B2C51414151412C474141472C494141492C4D41414D412C454141452C49414149412C454141452C494141492C4B41414B2C51414151412C474141472C4B41414B2C4D41414D412C4541';
wwv_flow_api.g_varchar2_table(163) := '41452C4D41414D2C51414151412C474141472C4D41414D2C4D41414D412C454141452C5341415367482C454141452C5341415368482C474141472C47414149442C474141452C4F4141512C4F41414F432C47414145412C49414149442C454141452C4741';
wwv_flow_api.g_varchar2_table(164) := '4147432C45414145442C494141496B482C454141452C534141536A482C474141472C47414149442C474141452C4F4141512C5141414F432C474141472C47414147412C49414149442C454141452C47414147432C45414145442C474141472C474141476D';
wwv_flow_api.g_varchar2_table(165) := '482C454141452C534141536C482C474141472C47414149442C474141452C4F4141512C5141414F432C474141472C494141492C45414145412C45414145412C494141492C47414147442C474141472C51414151432C45414145442C474141472C47414147';
wwv_flow_api.g_varchar2_table(166) := '2C4B41414B432C474141472C47414147412C494141492C47414147442C474141472C51414151432C45414145442C474141472C494141496F482C454141452C534141536E482C474141472C4F41414F2C4541414577472C4B41414B6F422C494141492C47';
wwv_flow_api.g_varchar2_table(167) := '4141472C4541414535482C4741414777472C4B41414B75422C4B41414B2C454141452F482C454141452C494141492C4541414577472C4B41414B73422C494141492C474141472C47414147562C454141452C5341415370482C474141472C47414149442C';
wwv_flow_api.g_varchar2_table(168) := '474141452C4F4141512C5141414F432C474141472C494141492C45414145412C45414145412C494141492C47414147442C474141472C51414151432C45414145442C474141472C474141472C4B41414B432C474141472C47414147412C494141492C4741';
wwv_flow_api.g_varchar2_table(169) := '4147442C474141472C51414151432C45414145442C474141472C4941414973482C454141452C5341415372482C474141472C47414149442C474141452C4F4141512C4F41414F432C47414145412C49414149442C454141452C47414147432C4541414544';
wwv_flow_api.g_varchar2_table(170) := '2C4941414975482C454141452C5341415374482C474141472C47414149442C474141452C4F4141512C5141414F432C474141472C47414147412C49414149442C454141452C47414147432C45414145442C474141472C4741414777482C454141452C5341';
wwv_flow_api.g_varchar2_table(171) := '415376482C474141472C4D41414F412C474141452C454141452C4B41414B2C4F41414F412C45414145412C45414145412C454141452C454141452C4B41414B2C51414151412C474141472C494141492C4D41414D412C454141452C49414149412C454141';
wwv_flow_api.g_varchar2_table(172) := '452C494141492C4B41414B2C51414151412C474141472C4B41414B2C4D41414D412C454141452C4D41414D2C51414151412C474141472C4D41414D2C4D41414D412C454141452C5341415377482C454141452C5341415378482C474141472C4D41414F41';
wwv_flow_api.g_varchar2_table(173) := '2C474141452C454141452C4B41414B2C4F41414F412C45414145412C45414145412C454141452C454141452C4B41414B2C474141472C51414151412C474141472C494141492C4D41414D412C454141452C4B41414B412C454141452C494141492C4B4141';
wwv_flow_api.g_varchar2_table(174) := '4B2C474141472C51414151412C474141472C4B41414B2C4D41414D412C454141452C4F41414F2C474141472C51414151412C474141472C4D41414D2C4D41414D412C454141452C5541415579482C454141452C534141537A482C474141472C4F41414F41';
wwv_flow_api.g_varchar2_table(175) := '2C474141472C494141492C454141452C4741414777472C4B41414B6F422C4941414935482C454141452C494141492C4B41414B412C474141472C4741414777472C4B41414B6F422C4941414935482C454141452C474141472C4941414930482C45414145';
wwv_flow_api.g_varchar2_table(176) := '2C5341415331482C474141472C4D41414F77472C4D41414B6F422C4941414935482C454141452C4941414932482C454141452C5341415333482C474141472C4D41414F77472C4D41414B6F422C4941414935482C454141452C4F41414F2C53414153412C';
wwv_flow_api.g_varchar2_table(177) := '45414145442C474141472C47414149442C45414145412C474141452C574141572C4D41414F482C514141512C4B414149472C45414145412C474141472C474141496D492C554141532C6942414169422C4D41414D6A492C474141472C674241416942522C';
wwv_flow_api.g_varchar2_table(178) := '554141534D2C454141454E2C51414151512C45414145622C51414151572C474141472C53414153452C45414145442C45414145442C474141472C59414171662C534141536B422C4741414568422C474141472C4D41414F6B492C554141536C492C454141';
wwv_flow_api.g_varchar2_table(179) := '452C4941417776442C514141536D482C474141456E482C474141472C47414149442C47414145432C4541414538442C654141652F442C45414145432C4541414569452C654141656A452C454141456F452C634141637A422C51414151512C474141476E44';
wwv_flow_api.g_varchar2_table(180) := '2C454141456D492C5741415770462C4541414568442C474141472C5141415371482C4741414570482C474141472C47414149442C47414145432C4541414538442C6341416368452C45414145452C4541414569452C6541416570452C45414145472C4541';
wwv_flow_api.g_varchar2_table(181) := '41456F452C614141616C452C45414145462C4541414567452C5141415133442C454141454C2C454141456D492C554141576E422C4741414539472C45414145472C494141494E2C45414145442C45414145442C4741414738432C514141512C5341415533';
wwv_flow_api.g_varchar2_table(182) := '432C474141472C4D41414F38432C4741414539432C454141454B2C4B41414D2C5141415367482C4741414572482C474141472C47414149442C47414145432C4541414538442C6341416368452C45414145452C4541414569452C6541416570452C454141';
wwv_flow_api.g_varchar2_table(183) := '45472C454141456F452C614141616C452C45414145462C4541414567452C5141415133442C454141454C2C454141456D492C5941415970492C45414145442C45414145442C4741414738432C514141512C5341415533432C474141472C4D41414F2B472C';
wwv_flow_api.g_varchar2_table(184) := '474141452F472C454141454B2C4B41414D34472C454141452F472C45414145472C474141472C5141415369482C4741414574482C45414145442C474141472C47414149442C474141456D422C4F41414F6D422C4B41414B70432C454141472C4941414769';
wwv_flow_api.g_varchar2_table(185) := '422C4F41414F6F422C7342414173422C434141432C4741414978432C474141456F422C4F41414F6F422C73424141734272432C45414147442C4B414149462C45414145412C4541414579432C4F41414F2C5341415576432C474141472C4D41414F6B422C';
wwv_flow_api.g_varchar2_table(186) := '5141414F73422C79424141794276432C45414145442C474141476F422C6341416572422C4541414530432C4B41414B432C4D41414D33432C45414145442C474141472C4D41414F432C474141452C5141415379482C4741414576482C474141472C494141';
wwv_flow_api.g_varchar2_table(187) := '492C47414149442C474141452C45414145412C4541414532432C554141552F422C4F41414F5A2C494141492C434141432C47414149442C474141452C4D41414D34432C5541415533432C4741414732432C5541415533432C4B41414D412C474141452C45';
wwv_flow_api.g_varchar2_table(188) := '41414575482C4541414572472C4F41414F6E422C494141472C4741414936432C514141512C5341415535432C4741414779482C4541414578482C45414145442C45414145442C45414145432C4D41414F6B422C4F41414F32422C30424141304233422C4F';
wwv_flow_api.g_varchar2_table(189) := '41414F34422C69424141694237432C4541414569422C4F41414F32422C30424141304239432C4941414977482C4541414572472C4F41414F6E422C4941414936432C514141512C5341415535432C474141476B422C4F41414F432C654141656C422C4541';
wwv_flow_api.g_varchar2_table(190) := '4145442C454141456B422C4F41414F73422C7942414179427A432C45414145432C4D41414F2C4D41414F432C474141452C5141415377482C4741414578482C45414145442C45414145442C474141472C4D41414F432C4B41414B432C4741414569422C4F';
wwv_flow_api.g_varchar2_table(191) := '41414F432C654141656C422C45414145442C4741414777422C4D41414D7A422C4541414571422C594141572C45414147592C634141612C45414147432C554141532C4941414B68432C45414145442C47414147442C45414145452C45414132612C514141';
wwv_flow_api.g_varchar2_table(192) := '536F492C4741414570492C474141472C4D41414F2C55414153412C474141472C4741414771492C4D41414D432C5141415174492C474141472C434141432C494141492C47414149442C474141452C45414145442C454141452C4741414975492C4F41414D';
wwv_flow_api.g_varchar2_table(193) := '72492C45414145572C514141515A2C45414145432C45414145572C4F41414F5A2C49414149442C45414145432C47414147432C45414145442C454141472C4F41414F442C4B414149452C494141492C53414153412C474141472C4741414771422C4F4141';
wwv_flow_api.g_varchar2_table(194) := '4F612C574141596A422C5141414F6A422C494141492C75424141754269422C4F41414F572C5541415532472C5341415337482C4B41414B562C474141472C4D41414F71492C4F41414D35432C4B41414B7A462C49414149412C494141492C574141572C4B';
wwv_flow_api.g_varchar2_table(195) := '41414D2C4941414932452C574141552C7344414173442C5141415336442C4741414578492C45414145442C474141472C494141492C47414149442C474141452C45414145412C45414145432C45414145592C4F41414F622C494141492C434141432C4741';
wwv_flow_api.g_varchar2_table(196) := '4149442C47414145452C45414145442C45414147442C4741414573422C5741415774422C4541414573422C614141592C4541414774422C454141456B432C634141612C454141472C534141556C432C4B414149412C454141456D432C554141532C474141';
wwv_flow_api.g_varchar2_table(197) := '49662C4F41414F432C654141656C422C45414145482C454141456F432C4941414970432C494141492C5141415334492C474141457A492C45414145442C474141472C47414149442C47414145432C4541414571422C4941414970422C454141472C4B4141';
wwv_flow_api.g_varchar2_table(198) := '49462C454141452C4B41414D2C4941414936452C574141552C694441416B442C4F41414F37452C4741414573422C4941414974422C4541414573422C49414149562C4B41414B562C47414147462C4541414579422C4D41417172432C514141536D482C47';
wwv_flow_api.g_varchar2_table(199) := '41414531492C45414145442C45414145442C45414145442C454141454B2C45414145472C474141472C474141494A2C474141454B2C45414145482C454141452C454141456A422C454141452C4541414534432C454141452C4541414568422C454141452C';
wwv_flow_api.g_varchar2_table(200) := '4541414536432C454141452C454141456C442C454141452C454141454F2C454141452C5341415368422C474141472C51414151472C45414145482C45414145642C47414147632C4541414538422C4741414739422C474141476B442C454141452C534141';
wwv_flow_api.g_varchar2_table(201) := '536C442C474141472C4F41414F2C45414145472C45414145482C454141452C45414145642C47414147632C4541414538422C4741414738422C454141452C5341415335442C474141472C4D41414F412C494141472C45414145412C454141452C45414145';
wwv_flow_api.g_varchar2_table(202) := '412C454141472C4F41414F472C474141452C4741414732422C454141452C454141452F422C49414149622C454141452C47414147572C45414145452C474141472B422C4741414768422C454141452C474141474C2C454141452C45414145582C49414149';
wwv_flow_api.g_varchar2_table(203) := '36442C454141452C474141477A442C454141454A2C47414147572C47414147522C45414145442C454141454D2C454141452C534141534E2C474141472C4D41414F2C494141472C49414149412C494141494B2C474141472C534141534C2C474141472C51';
wwv_flow_api.g_varchar2_table(204) := '414151632C45414145642C4541414532442C4741414733442C45414145532C47414147542C474141472C53414153412C45414145442C474141472C47414149442C47414145442C454141454B2C45414145472C454141454A2C454141454B2C434141452C';
wwv_flow_api.g_varchar2_table(205) := '4B4141494A2C45414145462C454141454D2C454141452C45414145412C454141452C45414145412C494141492C434141432C47414147442C45414145572C45414145642C47414147462C4541414534442C4541414576442C474141474E2C454141452C4D';
wwv_flow_api.g_varchar2_table(206) := '41414F472C454141452C49414147442C4541414569442C4541414568442C4741414730442C4541414533442C474141472C4B41414B2C4B41414D432C49414147472C454141454A2C454141452C49414149432C45414145462C49414149462C454141452C';
wwv_flow_api.g_varchar2_table(207) := '474141472C4D41414F412C454141452C49414147492C474141474C2C454141452C474141472C4D41414F412C454141452C4D41414B432C45414145442C474141472C434141432C47414147512C45414145572C45414145642C4741414730442C45414145';
wwv_flow_api.g_varchar2_table(208) := '76442C454141454C2C47414147442C454141452C4D41414F472C45414145462C474141454B2C45414145502C45414145492C454141454C2C454141454B2C45414145412C454141452C494141494C2C45414145432C47414147412C454141452C4D41414F';
wwv_flow_api.g_varchar2_table(209) := '492C49414147442C454141454B2C494141376A4D522C45414145442C45414145452C454141472C49414149462C4B41414B432C47414145442C45414145412C47414147432C454141456B422C454141456E422C454141452C594141592C574141592C4D41';
wwv_flow_api.g_varchar2_table(210) := '414F71482C4B41414B70482C454141456B422C454141456E422C454141452C654141652C574141592C4D41414F73482C4B41414B72482C454141456B422C454141456E422C454141452C634141632C574141592C4D41414F75482C4B41414B74482C4541';
wwv_flow_api.g_varchar2_table(211) := '41456B422C454141456E422C454141452C614141612C574141592C4D41414F77482C4941414B2C494141496E482C47414145472C454141454A2C45414145482C454141452C47414147512C454141452C59414159482C454141452C6742414167426A422C';
wwv_flow_api.g_varchar2_table(212) := '454141452C5941415934432C4741414735422C4541414568422C45414145794A2C4F41414F74492C454141452C4F41414F73492C4F41414F2C47414149432C5141414F2C53414153432C4F41414F33492C4741414732492C4F41414F78492C4741414777';
wwv_flow_api.g_varchar2_table(213) := '492C4F41414F33492C4741414732492C4F41414F78492C4741414777492C4F41414F33492C454141452C4F41414F2C4D41414D592C454141452C5141415136432C454141452C7742414177426C442C454141452C53414153542C45414145442C47414147';
wwv_flow_api.g_varchar2_table(214) := '2C4D41414F432C4741414538492C494141492C5341415539492C45414145462C474141472C4D41414D2C494141492B492C4F41414F39492C454141452C4B41414B38492C4F41414F2F492C4D41412B436F442C454141452C534141536C442C474141472C';
wwv_flow_api.g_varchar2_table(215) := '4D41414D2C4F41414F36492C5141415139492C45414145432C454141452C4B41414B442C45414145412C45414145674A2C514141512C494141492C4B41414B70492C534141535A2C47414147412C45414145412C45414145694A2C4D41414D2C4B41414B';
wwv_flow_api.g_varchar2_table(216) := '2C474141476A4A2C454141452C47414147412C454141452C47414147412C454141452C47414147412C454141452C47414147412C454141452C4B41414B69422C454141456A422C454141456B4A2C4F41414F2C454141452C494141496A492C454141456A';
wwv_flow_api.g_varchar2_table(217) := '422C454141456B4A2C4F41414F2C454141452C494141496A492C454141456A422C454141456B4A2C4F41414F2C454141452C4D41414D432C4B41414B2C4B41414B2C4941414B2C494141496E4A2C4941414736442C454141452C5341415335442C454141';
wwv_flow_api.g_varchar2_table(218) := '45442C45414145442C474141472C47414149442C47414145452C454141456F4A2C4D41414D6E4A2C47414147452C45414145482C45414145674A2C514141512F492C454141452C4D41414F2C4F41414F482C49414147412C4541414538432C514141512C';
wwv_flow_api.g_varchar2_table(219) := '5341415533432C474141472C4D41414F452C47414145412C4541414536492C514141512C4D41414D6A4A2C45414145452C4D41414F452C4741414769442C454141452C534141536E442C474141472C494141492C47414149442C4B41414B432C47414145';
wwv_flow_api.g_varchar2_table(220) := '2C434141432C47414149462C47414145452C45414145442C454141472C694241416942442C49414147412C45414145714A2C4D41414D78462C4B41414B33442C45414145442C4741414736442C45414145442C4541414537442C454141456F442C4D4141';
wwv_flow_api.g_varchar2_table(221) := '4D6E432C454141452C53414153662C474141472C47414149442C47414145432C454141456D4A2C4D41414D6A4B2C47414147344A2C4941414974432C4B41414B34432C4D414175422C4F41414D2C47414147502C4F4141764237492C454141456D4A2C4D';
wwv_flow_api.g_varchar2_table(222) := '41414D72492C474141472C49414173422B482C4F41414F39492C454141456D4A2C4B41414B2C4B41414B2C4D41414D334A2C454141452C53414153532C474141472C4D41414F412C474141456D4A2C4D41414D6A4B2C4941414936442C454141452C5341';
wwv_flow_api.g_varchar2_table(223) := '41532F432C474141472C47414149442C47414145442C45414145442C4941414B2C4B4141492C474141494B2C4B41414B462C474141452C434141432C474141494B2C474141454C2C45414145452C454141472C694241416942472C4B414149522C454141';
wwv_flow_api.g_varchar2_table(224) := '454B2C494141496D4A2C63414163744A2C454141454D2C45414145502C4D4141452C4741414F412C45414145432C454141456F4A2C4D41414D684A2C474141474C2C474141472C49414149412C45414145612C514141515A2C45414145754A2C4F41414F';
wwv_flow_api.g_varchar2_table(225) := '2C47414147482C4D41414D37492C4B41414B522C45414145794A2C514141512C494141497A4A2C474141472C474141472C49414149412C454141456F4A2C4B41414B2C514141514D2C574141572F492C454141456C422C45414145632C47414147482C4B';
wwv_flow_api.g_varchar2_table(226) := '41414B2C4D41414F4C2C4941414769442C454141452C5341415339432C45414145442C474141472C47414149442C474141452C53414153412C47414147502C45414145532C45414145462C4941414936432C514141512C5341415539432C454141454B2C';
wwv_flow_api.g_varchar2_table(227) := '474141472C4D41414F462C47414145442C45414145442C47414147304A2C57414157744A2C4B41414B4C2C55414159472C47414145462C474141492C4B4141492C47414149442C4B41414B452C47414145442C45414145442C4941414971472C45414145';
wwv_flow_api.g_varchar2_table(228) := '2C534141536C472C45414145442C474141472C47414149442C4B41414B2C4F41414F432C4741414534432C514141512C5341415535432C47414147442C45414145432C47414147432C45414145442C53414155432C47414145442C4B41414D442C474141';
wwv_flow_api.g_varchar2_table(229) := '472B472C454141452C5341415337472C45414145442C474141472C4D41414F412C474141452B492C494141492C534141552F492C474141472C4D41414F432C47414145442C4D41414F2B472C454141452C5341415339472C45414145442C474141472C4D';
wwv_flow_api.g_varchar2_table(230) := '41414F412C4741414534432C514141512C5341415535432C474141472C4D41414F432C47414145412C454141452B492C514141512C4F41414F684A2C45414145304A2C514141512C4D41414F7A4A2C474141472B472C454141452C534141532F472C4541';
wwv_flow_api.g_varchar2_table(231) := '4145442C474141472C494141492C47414149442C4B41414B432C474141452C434141432C47414149462C47414145452C45414145442C47414147492C454141454C2C45414145324A2C574141576E4A2C45414145522C45414145774A2C61414161704A2C';
wwv_flow_api.g_varchar2_table(232) := '4541414536472C454141457A472C4541414577472C45414145582C454141456C472C45414145452C47414147412C47414149462C47414145462C4741414738442C4541414539422C4541414537422C45414145632C4B41414B69472C454141452C534141';

wwv_flow_api.g_varchar2_table(233) := '5368482C45414145442C474141472C47414149442C474141452C53414153412C474141472C47414149442C47414145452C45414145442C47414147304A2C57414157744A2C45414145462C45414145462C454141472C494141472C674241416942492C47';
wwv_flow_api.g_varchar2_table(234) := '4141452C434141432C47414149472C47414145482C4541414538492C4D41414D2C4B41414B2F492C45414145492C45414145412C454141454D2C4F41414F2C45414147642C4741414538432C514141512C5341415535432C45414145442C474141472C4D';
wwv_flow_api.g_varchar2_table(235) := '41414F452C47414145442C474141474D2C45414145502C49414149472C514141554A2C4741414538432C514141512C5341415535432C474141472C4D41414F432C47414145442C47414147472C55414159462C47414145462C474141492C4B4141492C47';
wwv_flow_api.g_varchar2_table(236) := '414149442C4B41414B452C47414145442C45414145442C494141496F482C454141452C534141536A482C45414145442C474141472C494141492C47414149442C4B41414B432C474141452C434141432C47414149462C47414145452C45414145442C4741';
wwv_flow_api.g_varchar2_table(237) := '4147304A2C57414157744A2C45414145462C45414145482C454141452C47414149472C47414145462C474141472C674241416942492C474141454C2C45414145694A2C494141492C534141552F492C474141472C47414149442C47414145452C45414145';
wwv_flow_api.g_varchar2_table(238) := '442C454141472C63414163432C47414145442C47414147442C4941414B6F4A2C4B41414B2C4B41414B684A2C4941414967482C454141452C534141536C482C474141472C47414149442C47414145432C4541414538442C614141632C4F41414F37432C51';
wwv_flow_api.g_varchar2_table(239) := '41414F6D422C4B41414B72432C47414147324A2C4B41414B2C53414155314A2C474141472C4D41414D2C674241416942442C47414145432C4D4141756C4379482C454141452C4741414978482C474141454B2C454141456F482C454141457A482C454141';
wwv_flow_api.g_varchar2_table(240) := '454B2C4541414532462C5141415130422C454141452C5341415333482C45414145442C45414145442C45414145442C474141472C474141494B2C4741414577432C554141552F422C4F41414F2C4F4141472C4B4141532B422C554141552C47414147412C';
wwv_flow_api.g_varchar2_table(241) := '554141552C474141472C4541414572432C454141456B482C4B41414B76482C474141474D2C45414145572C4F41414F68422C4541414538432C474141472F432C45414145482C454141472C4B4141492C474141494D2C4B41414B73482C4741414535432C';
wwv_flow_api.g_varchar2_table(242) := '534141536C452C4F41414F2C4541414538472C454141456B432C514141516C432C4541414533442C634141637A442C454141456F482C4541414578442C654141656A452C4541414579482C4541414572442C6141416172452C4541414530482C45414145';
wwv_flow_api.g_varchar2_table(243) := '7A442C5141415131442C454141456F482C45414145412C4541414576482C4741414767472C5541415573422C49414149412C4541414535432C5341415372432C4B41414B6B462C4541414576482C4741414973482C474141456C442C614141612C674241';
wwv_flow_api.g_varchar2_table(244) := '4167426B442C454141456C442C614141612C634141652C4941414972462C474141452B422C4F41414F68422C45414145482C47414147412C454141454F2C454141454C2C45414145442C454141452C45414145472C45414145492C454141472C4F41414F';
wwv_flow_api.g_varchar2_table(245) := '6D482C474141456C442C614141612C6341416372462C474141677042304B2C454141452C574141572C51414153354A2C4D41414B2C53414153412C45414145442C474141472C4B41414B432C59414161442C494141472C4B41414D2C4941414934452C57';
wwv_flow_api.g_varchar2_table(246) := '4141552C73434141734368462C4B41414B4B2C47414147364A2C45414145462C49414149684B2C4D41414D71432C554141532C45414147542C554141572C4B4141492C4741414978422C4741414532432C554141552F422C4F41414F622C454141452C47';
wwv_flow_api.g_varchar2_table(247) := '41414975492C4F41414D74492C47414147462C454141452C45414145412C45414145452C45414145462C49414149432C45414145442C4741414736432C5541415537432C45414147432C4741414536432C5141415168442C4B41414B6D4B2C4941414970';
wwv_flow_api.g_varchar2_table(248) := '492C4B41414B2F422C4F41414F2C47414149492C47414145442C45414145442C434141452C4F41414F452C47414145432C47414147462C494141496D432C494141492C4D41414D562C4D41414D2C5341415376422C474141472C4D41414F79492C474141';
wwv_flow_api.g_varchar2_table(249) := '4539492C4B41414B6B4B2C4741414772482C4B41414B78432C47414147412C4B41414B69432C494141492C53414153562C4D41414D2C5341415376422C474141472C47414149442C4741414530492C4541414539492C4B41414B6B4B2C47414147452C51';
wwv_flow_api.g_varchar2_table(250) := '4141512F4A2C454141472C5141414F442C4741414730492C4541414539492C4B41414B6B4B2C47414147472C4F41414F6A4B2C454141452C47414147432C4B41414B69432C494141492C51414151562C4D41414D2C574141572C4D41414F35422C4D4141';
wwv_flow_api.g_varchar2_table(251) := '4B734B2C574141576E422C494141496E4A2C4B41414B754B2C4F41414F78492C4B41414B2F422C5541415573432C494141492C59414159562C4D41414D2C574141572C4D41414F6B482C4741414539492C4B41414B6B4B2C47414147482C4B41414B2C53';
wwv_flow_api.g_varchar2_table(252) := '414155314A2C474141472C4D41414F412C474141456D4B2C694241416B426C492C494141492C4F41414F562C4D41414D2C574141572C4D41414F6B482C4741414539492C4B41414B6B4B2C474141476C482C514141512C5341415533432C474141472C4D';
wwv_flow_api.g_varchar2_table(253) := '41414F412C4741414567442C5541415772442C5141415173432C494141492C51414151562C4D41414D2C574141572C4D41414F6B482C4741414539492C4B41414B6B4B2C474141476C482C514141512C5341415533432C474141472C4D41414F412C4741';
wwv_flow_api.g_varchar2_table(254) := '41456F4B2C554141577A4B2C5141415173432C494141492C53414153562C4D41414D2C574141572C4D41414F6B482C4741414539492C4B41414B6B4B2C474141476C482C514141512C5341415533432C474141472C4D41414F412C474141456F462C5741';
wwv_flow_api.g_varchar2_table(255) := '41597A462C5141415173432C494141492C4F41414F562C4D41414D2C5341415376422C474141472C4D41414F79492C4741414539492C4B41414B6B4B2C474141476C482C514141512C5341415535432C474141472C4D41414F412C4741414575452C4B41';
wwv_flow_api.g_varchar2_table(256) := '414B74452C4B41414D4C2C5141415173432C494141492C61414161622C494141492C574141572C4D41414F67482C474141454B2C4541414539492C4B41414B6B4B2C4F41414F35482C494141492C57414157622C494141492C574141572C4D41414F7148';
wwv_flow_api.g_varchar2_table(257) := '2C4741414539492C4B41414B6B4B2C47414147662C494141492C5341415539492C474141472C4D41414F412C474141456F472C6742414169426F432C454141457A492C4541414536422C5541415539422C47414147442C4741414732492C454141457A49';
wwv_flow_api.g_varchar2_table(258) := '2C45414145462C47414147472C4B41414B364A2C454141452C47414149512C534141676942432C454141452C53414153744B2C45414145442C45414145442C45414145442C454141454B2C474141472C47414149472C474141452C534141534C2C454141';
wwv_flow_api.g_varchar2_table(259) := '45442C45414145442C45414145442C474141472C4D41414F2C554141534B2C474141472C4D41414F77492C4741414578492C45414145462C45414145442C45414145442C45414145442C454141452C4B41414B452C45414145442C45414145442C454141';
wwv_flow_api.g_varchar2_table(260) := '454B2C454141472C4F41414F472C474141456B4B2C59414159764B2C454141454B2C454141456D4B2C474141477A4B2C454141454D2C454141456F4B2C47414147334B2C454141454F2C45414145714B2C47414147374B2C45414145512C45414145734B';
wwv_flow_api.g_varchar2_table(261) := '2C474141477A4B2C45414145442C454141454B2C4541414571472C5341415333472C474141474B2C47414147754B2C454141452C53414153354B2C474141472C61414163432C474141454B2C4541414571472C5341415333472C47414149462C47414145';
wwv_flow_api.g_varchar2_table(262) := '6B422C454141456A422C454141452C6742414167422C574141592C4D41414F452C47414145452C4941414B4C2C454141456B422C454141456A422C454141452C594141592C574141592C4D41414F452C474141454B2C4941414B522C454141456B422C45';
wwv_flow_api.g_varchar2_table(263) := '4141456A422C454141452C514141512C574141592C4D41414F452C47414145652C4941414B6C422C454141456B422C454141456A422C454141452C634141632C574141592C4D41414F34482C4B41414B37482C454141456B422C454141456A422C454141';
wwv_flow_api.g_varchar2_table(264) := '452C514141512C574141592C4D41414F364A2C4B41414B394A2C454141456B422C454141456A422C454141452C6F4241416F422C574141592C4D41414F754B2C4B41414B784B2C454141456B422C454141456A422C454141452C7342414173422C574141';
wwv_flow_api.g_varchar2_table(265) := '592C4D41414F364B2C4B41414B334B2C454141454B2C4541414532462C5141415134452C4D41414D684C2C594145722F52694C2C474141472C53414153314B2C4541415168422C4541414F442C4741476A432C47414149344C2C47414151334B2C454141';
wwv_flow_api.g_varchar2_table(266) := '512C5741436842344B2C45414151354B2C454141512C5741456842364B2C454141532C5341416742432C45414157432C4741477043784C2C4B41414B794C2C634143442C714741494A7A4C2C4B41414B304C2C7142414175422C45414535424E2C454141';
wwv_flow_api.g_varchar2_table(267) := '4D74492C4D41414D39432C4B41414D2B432C574147744275492C4741414F724A2C554141592C474141496D4A2C4741437642452C4541414F724A2C554141554F2C5941416338492C4541452F42412C4541414F724A2C55414155304A2C594141632C5341';
wwv_flow_api.g_varchar2_table(268) := '417142432C47414368442C47414149432C47414165442C4541414B452C5741437042462C4741414B472C59414163482C4541414B472C57414161482C4541414B452C6341433143442C45414165442C4541414B472C57414778422C49414149374C2C4741';
wwv_flow_api.g_varchar2_table(269) := '41492C4741414B324C2C454141652C43414535422C4F41414F522C4741414D572C4F41414F684D2C4B41414B794C2C6541437242512C4F4141512F4C2C45414352674D2C554141652C4541414A684D2C4B41496E426F4C2C4541414F724A2C554141556B';
wwv_flow_api.g_varchar2_table(270) := '4B2C614141652C5341417342502C4741436C442C4D41414F354C2C4D41414B324C2C59414159432C49414735426E4D2C4541414F442C51414155384C2C49414564632C554141552C45414145432C554141552C49414149432C474141472C53414153374C';
wwv_flow_api.g_varchar2_table(271) := '2C4541415168422C4541414F442C47414778442C47414149344C2C47414151334B2C454141512C5741436842344B2C45414151354B2C454141512C5741456842384C2C4541414F2C5341416368422C45414157432C4741436843784C2C4B41414B794C2C';
wwv_flow_api.g_varchar2_table(272) := '6341416742442C4541415167422C53414376422C38424143412C384241434E70422C4541414D74492C4D41414D39432C4B41414D2B432C5741477442774A2C4741414B744B2C554141592C474141496D4A2C47414372426D422C4541414B744B2C554141';
wwv_flow_api.g_varchar2_table(273) := '554F2C594141632B4A2C4541453742412C4541414B744B2C55414155774B2C65414169422C5341417742432C4541414B642C4741437A442C47414149652C47414161662C4541414B592C53414368422C4F4141535A2C4541414B452C594141632C4F4143';
wwv_flow_api.g_varchar2_table(274) := '35422C57414161462C4541414B452C5741437842592C47414149452C614141612C55414157442C4741433542442C45414149452C614141612C7342414175422C53414735434C2C4541414B744B2C55414155304A2C594141632C5341417142432C474143';
wwv_flow_api.g_varchar2_table(275) := '39432C4D41414F502C4741414D572C4F41414F684D2C4B41414B794C2C65414372426F422C4F4141516A422C4541414B452C594141632C4B41496E43532C4541414B744B2C554141556B4B2C614141652C5341417342502C47414368442C4D41414F354C';
wwv_flow_api.g_varchar2_table(276) := '2C4D41414B324C2C59414159432C49414735426E4D2C4541414F442C514141552B4D2C49414564482C554141552C45414145432C554141552C49414149532C474141472C53414153724D2C4541415168422C4541414F442C4741437844432C4541414F44';
wwv_flow_api.g_varchar2_table(277) := '2C534145482B4D2C4B41414D394C2C454141512C55414364364B2C4F414151374B2C454141512C5941436842734D2C57414159744D2C454141512C674241437042754D2C4F414151764D2C454141512C5941476842774D2C4B41414D784D2C454141512C';
wwv_flow_api.g_varchar2_table(278) := '55414B64324B2C4D41414F334B2C454141512C57414766344B2C4D41414F354B2C454141512C6341476842794D2C574141572C45414145432C534141532C45414145432C534141532C45414145432C654141652C454141456A422C554141552C45414145';
wwv_flow_api.g_varchar2_table(279) := '6B422C574141572C454141456A422C554141552C494141496B422C474141472C53414153394D2C4541415168422C4541414F442C4741477A482C4741414930422C47414153542C454141512C5541436A42344B2C45414151354B2C454141512C57414568';
wwv_flow_api.g_varchar2_table(280) := '422B4D2C45414159744D2C4541414F734D2C5541456E42432C47414341432C4F4141512C63414352432C514141532C65414354432C554141572C6B42414758582C4541414F2C51414153412C4741414B592C4541414D6A432C47414533422C4B41414D35';
wwv_flow_api.g_varchar2_table(281) := '4C2C6541416742694E2C4941436C422C4B41414D2C49414149724D2C4F41414D2C364341497042674C2C4741414F502C4541414D79432C514143546E492C4D41414F2C45414350432C534141552C49414356432C4F4141512C53414352432C514143414B';
wwv_flow_api.g_varchar2_table(282) := '2C4D414341442C4B41414D2C6341435030462C454145482C494141496D432C45414541412C4741444131432C4541414D32432C53414153482C4741434C492C53414153432C634141634C2C4741457642412C45414964374E2C4B41414B364E2C4B41414F';
wwv_flow_api.g_varchar2_table(283) := '452C4541435A2F4E2C4B41414B6D4F2C4D41415176432C45414362354C2C4B41414B6F4F2C574141612C4941476C422C49414149704E2C4741415368422C4B41414B364E2C4B41414B512C674241437642724F2C4D41414B364E2C4B41414B532C4D4141';
wwv_flow_api.g_varchar2_table(284) := '4D432C674241416B42764E2C454141532C4941414D412C4541436A4468422C4B41414B674B2C494141492C4741476269442C4741414B684C2C554141554C2C4D4141512C5741436E422C47414149344D2C47414153784F2C4B41414B794F2C7942414364';
wwv_flow_api.g_varchar2_table(285) := '7A4E2C4541415368422C4B41414B364E2C4B41414B512C694241456E424B2C454141572C45414149462C45414153784E2C43414735422C4F41414F324E2C59414157442C4541415335452C514141512C474141492C4B414733436D442C4541414B684C2C';
wwv_flow_api.g_varchar2_table(286) := '554141552B482C4941414D2C5341416130452C4741433942314F2C4B41414B32452C4F41454C33452C4B41414B364E2C4B41414B532C4D41414D4D2C694241416D42354F2C4B41414B364F2C6B4241416B42482C45414531442C4941414978492C474141';
wwv_flow_api.g_varchar2_table(287) := '4F6C472C4B41414B6D4F2C4D41414D6A492C49414374422C494141496D462C4541414D79442C5741415735492C4741414F2C43414378422C474141494C2C4741415337462C4B41414B71452C5141415172452C4B41414B6D4F2C4D41414D74492C4F4147';
wwv_flow_api.g_varchar2_table(288) := '72434B2C474146616C472C4B41414B2B4F2C614141614C2C4541415537492C4741437A4237462C4B41414B6D4F2C4D41414D612C4F41415368502C4B41435A412C4B41414B6D4F2C4D41414D7A492C634149334375482C4541414B684C2C554141553043';
wwv_flow_api.g_varchar2_table(289) := '2C4B41414F2C5741436C4233452C4B41414B69502C6141434C6A502C4B41414B364E2C4B41414B532C4D41414D4D2C694241416D42354F2C4B41414B794F2C3042414B354378422C4541414B684C2C55414155694E2C514141552C5341416942522C4541';
wwv_flow_api.g_varchar2_table(290) := '415539432C4541414D75442C474143744476442C4541414F412C4D414548502C4541414D79442C574141576C442C4B41436A4275442C4541414B76442C4541434C412C4B41474A2C4941414977442C474141612F442C4541414D79432C554141576C432C';
wwv_flow_api.g_varchar2_table(291) := '474147394279442C4541416368452C4541414D79432C55414157394E2C4B41414B6D4F2C4D4143784376432C4741414F502C4541414D79432C4F41414F75422C454141617A442C4541456A432C4941414930442C4741416574502C4B41414B71452C5141';
wwv_flow_api.g_varchar2_table(292) := '415175482C4541414B2F462C5141436A43304A2C4541415376502C4B41414B77502C6B4241416B42642C45414155592C45414163462C454145354470502C4D41414B32452C4F41494C33452C4B41414B364E2C4B41414B34422C75424145562C49414149';
wwv_flow_api.g_varchar2_table(293) := '6A422C47414153784F2C4B41414B794F2C794241436469422C4541415931502C4B41414B364F2C6B4241416B42482C4741456E43334F2C4541414F432C49414358412C4D41414B6F4F2C574141612C474141495A2C4741437442784E2C4B41414B6F4F2C';
wwv_flow_api.g_varchar2_table(294) := '574141572F4B2C4F41435A79432C4B41414D75462C4541414D79432C51414153552C4F414151412C47414155652C4541414F7A4A2C4D414339434B2C474141496B462C4541414D79432C51414153552C4F4141516B422C47414161482C4541414F704A2C';
wwv_flow_api.g_varchar2_table(295) := '4941432F43502C5341415567472C4541414B68472C53414366442C4D41414F69472C4541414B6A472C4D41435A452C4F414151794A2C45414352704A2C4B41414D2C53414153794A2C4741435835502C4541414B384E2C4B41414B532C4D41414D4D2C69';
wwv_flow_api.g_varchar2_table(296) := '4241416D42652C4541414D6E422C4D41437A432C494141496F422C4741415968452C4541414B6F442C4F4141536A502C4341433942364C2C4741414B31462C4B41414B794A2C4541414F432C4541415768452C4541414B6C472C65414574436D4B2C4B41';
wwv_flow_api.g_varchar2_table(297) := '414B2C53414153462C4741435474452C4541414D79442C574141574B2C4941436A42412C4D41454C76492C4D41414D2C534141536B4A2C474145642C4B414441432C53414151432C4D41414D2C714241417342462C4741433942412C4B41496437432C45';
wwv_flow_api.g_varchar2_table(298) := '41414B684C2C55414155774D2C7542414179422C57414370432C4741414977422C474141674270512C4F41414F71512C6942414169426C512C4B41414B364E2C4B41414D2C4B414376442C4F41414F632C5941415773422C45414163452C694241416942';
wwv_flow_api.g_varchar2_table(299) := '2C7142414173422C4B414733456C442C4541414B684C2C55414155344D2C6B4241416F422C5341413242482C47414331442C47414149314E2C4741415368422C4B41414B364E2C4B41414B512C6742414376422C4F41414F724E2C47414153304E2C4541';
wwv_flow_api.g_varchar2_table(300) := '4157314E2C4741492F42694D2C4541414B684C2C55414155754E2C6B4241416F422C5341413242642C4541415537492C454141512B462C47414335452C4D414149412C4741414B39462C4D41415138462C4541414B7A462C494145644C2C4B41414D3846';
wwv_flow_api.g_varchar2_table(301) := '2C4541414B39462C4B4143584B2C4741414979462C4541414B7A462C4B414B624C2C4B41414D39462C4B41414B6F512C65414165764B2C47414331424D2C474141496E472C4B41414B2B4F2C614141614C2C4541415537492C4B414B78436F482C454141';
wwv_flow_api.g_varchar2_table(302) := '4B684C2C554141556D4F2C65414169422C5341417742764B2C47414370442C4D41414F33452C4741414F6D502C5941415972512C4B41414B6D4F2C4D41414D72492C4B41414D39462C4B41414B6D4F2C4D41414D68492C474141496E472C4B41414B3442';
wwv_flow_api.g_varchar2_table(303) := '2C5141415369452C49414935456F482C4541414B684C2C55414155384D2C614141652C53414173424C2C4541415537492C47414331442C4D41414F33452C4741414F6D502C5941415972512C4B41414B6D4F2C4D41414D72492C4B41414D39462C4B4141';
wwv_flow_api.g_varchar2_table(304) := '4B6D4F2C4D41414D68492C4741414975492C4541415537492C49414778456F482C4541414B684C2C55414155674E2C574141612C574143412C4F414170426A502C4B41414B6F4F2C6141434C704F2C4B41414B6F4F2C574141577A4A2C4D41414B2C4741';
wwv_flow_api.g_varchar2_table(305) := '43724233452C4B41414B6F4F2C574141612C4F414931426E422C4541414B684C2C554141556F432C514141552C534141694277422C47414374432C4D41414934482C47414165764C2C6541416532442C474143764234482C4541416535482C4741476E42';
wwv_flow_api.g_varchar2_table(306) := '412C4741475870472C4541414F442C51414155794E2C494145645A2C554141552C454141456E4C2C4F4141532C494141496F502C474141472C5341415337502C4541415168422C4541414F442C47414776442C47414149344C2C47414151334B2C454141';
wwv_flow_api.g_varchar2_table(307) := '512C5741436842364B2C45414153374B2C454141512C5941436A42344B2C45414151354B2C454141512C5741456842734D2C454141612C5341416F4278422C45414157432C4741473543784C2C4B41414B794C2C634143442C384441474A7A4C2C4B4141';
wwv_flow_api.g_varchar2_table(308) := '4B304C2C7142414175422C45414535424E2C4541414D74492C4D41414D39432C4B41414D2B432C5741477442674B2C47414157394B2C554141592C474141496D4A2C474143334232422C45414157394B2C554141554F2C59414163754B2C4541456E4341';
wwv_flow_api.g_varchar2_table(309) := '2C45414157394B2C55414155774B2C65414169422C5341417742432C4541414B642C4741432F44632C45414149452C614141612C554141572C6541476843472C45414157394B2C55414155734F2C7942414132422C534143354333452C454143414C2C45';
wwv_flow_api.g_varchar2_table(310) := '41434169462C4741454935452C4541414B36452C4B41414B6E432C514145566B432C454141636C432C4D41414D6F432C4941414D2C4F41433142462C454141636C432C4D41414D71432C4F4141532C4941457A422F452C4541414B36452C4B41414B472C';
wwv_flow_api.g_varchar2_table(311) := '6341435676462C4541414D77462C534141534C2C454141652C594141612C7342414533436E462C4541414D77462C534141534C2C454141652C594141612C3042414D76447A442C45414157394B2C55414155304A2C594141634C2C4541414F724A2C5541';
wwv_flow_api.g_varchar2_table(312) := '4155304A2C59414370446F422C45414157394B2C554141556B4B2C61414165622C4541414F724A2C554141556B4B2C6141457244314D2C4541414F442C51414155754E2C49414564472C574141572C45414145642C554141552C45414145432C55414155';
wwv_flow_api.g_varchar2_table(313) := '2C4941414979452C474141472C5341415372512C4541415168422C4541414F442C47414772452C47414149794E2C4741414F784D2C454141512C55414366344B2C45414151354B2C454141512C574145684273512C4541416B422C734241456C4233462C';
wwv_flow_api.g_varchar2_table(314) := '454141512C51414153412C4741414D472C454141574B2C4741476C432C4B41414D354C2C65414167426F4C2C4941436C422C4B41414D2C49414149784B2C4F41414D2C3643415370422C49414179422C49414172426D432C554141552F422C4F4141642C';
wwv_flow_api.g_varchar2_table(315) := '43414B4168422C4B41414B6D4F2C4D41415139432C4541414D79432C514143666B442C4D41414F2C4F4143506C462C594141612C454143626D462C574141592C4B41435A6C462C574141592C4B41435A6D462C4B41414D2C4B41434E542C4D4143496E43';
wwv_flow_api.g_varchar2_table(316) := '2C4F41434930432C4D41414F2C4B414350472C534141552C57414356432C4B41414D2C4D41434E562C4941414B2C4D41434C572C514141532C45414354432C4F4141512C45414352432C57414349432C514141512C4541435235502C4D41414F2C304241';
wwv_flow_api.g_varchar2_table(317) := '476636502C6F4241416F422C4541437042622C654141652C4541436668502C4D41414F2C4B41435038502C554141572C6F42414566432C55414349432C514141532C51414354432C4D41414F2C51414558432C554141552C474143586C472C4741414D2C';
wwv_flow_api.g_varchar2_table(318) := '4741494C502C4541414D30472C534141536E472C51414132426F472C4B41416C4270472C4541414B2B462C574143374233522C4B41414B6D4F2C4D41414D77442C534141572F462C4541414B2B462C554145334274472C4541414D30472C534141536E47';
wwv_flow_api.g_varchar2_table(319) := '2C49414153502C4541414D30472C534141536E472C4541414B36452C574141364275422C4B4141704270472C4541414B36452C4B41414B6E432C5141432F44744F2C4B41414B6D4F2C4D41414D73432C4B41414B6E432C4D41415131432C4541414B3645';
wwv_flow_api.g_varchar2_table(320) := '2C4B41414B6E432C4D414774432C49414549502C474146416B452C454141556A532C4B41414B6B532C654141656C532C4B41414B6D4F2C4D415376432C4D414C494A2C4541444131432C4541414D32432C534141537A432C4741434C30432C5341415343';
wwv_flow_api.g_varchar2_table(321) := '2C6341416333432C4741457642412C474149562C4B41414D2C49414149334B2C4F41414D2C364241412B42324B2C4541476E44764C2C4D41414B6D532C5741416170452C4541436C422F4E2C4B41414B6D532C57414157432C59414159482C4541415176';
wwv_flow_api.g_varchar2_table(322) := '462C4B41436843314D2C4B41414B6D4F2C4D41414D32442C5541435839522C4B41414B71532C30424141304272532C4B41414B6D532C59414770436E532C4B41414B6D4F2C4D41414D77442C5541435874472C4541414D69482C554141554C2C45414151';
wwv_flow_api.g_varchar2_table(323) := '76462C4941414B314D2C4B41414B6D4F2C4D41414D77442C554149354333522C4B41414B304D2C4941414D75462C4541415176462C4941436E42314D2C4B41414B364E2C4B41414F6F452C4541415170452C4B41437042374E2C4B41414B75532C4D4141';
wwv_flow_api.g_varchar2_table(324) := '514E2C454141514D2C4D4143724276532C4B41414B79512C4B41414F2C4941455A2C494141492B422C474141556E482C4541414D79432C514143684270492C65414159734D2C4741435A68442C4D41414F68502C4D414352412C4B41414B6D4F2C4D4143';
wwv_flow_api.g_varchar2_table(325) := '526E4F2C4D41414B79532C63414167422C4741414978462C4741414B67462C4541415170452C4B41414D32452C47414578436E482C4541414D30472C534141532F522C4B41414B6D4F2C4D41414D73432C4F41416D432C4F414131427A512C4B41414B6D';
wwv_flow_api.g_varchar2_table(326) := '4F2C4D41414D73432C4B41414B374F2C4F41436E4435422C4B41414B30532C5141415131532C4B41414B6D4F2C4D41414D73432C4B41414B374F2C5141497243774A2C4741414D6E4A2C55414155694E2C514141552C5341416942522C4541415539432C';
wwv_flow_api.g_varchar2_table(327) := '4541414D75442C47414376442C47414132422C4F414176426E502C4B41414B79532C6341434C2C4B41414D2C4941414937522C4F41414D6D512C45414770422F512C4D41414B79532C6341416376442C51414151522C4541415539432C4541414D75442C';
wwv_flow_api.g_varchar2_table(328) := '4941472F432F442C4541414D6E4A2C5541415530432C4B41414F2C5741436E422C47414132422C4F4141764233452C4B41414B79532C6341434C2C4B41414D2C4941414937522C4F41414D6D512C4F41494F69422C4B4141764268532C4B41414B79532C';
wwv_flow_api.g_varchar2_table(329) := '654149547A532C4B41414B79532C63414163394E2C514147764279472C4541414D6E4A2C5541415577492C4D4141512C57414370422C47414132422C4F414176427A4B2C4B41414B79532C6341434C2C4B41414D2C4941414937522C4F41414D6D512C4F';
wwv_flow_api.g_varchar2_table(330) := '41474F69422C4B4141764268532C4B41414B79532C6541494A7A532C4B41414B79532C6341416372452C59414B7842704F2C4B41414B79532C6341416372452C5741415733442C5341476C43572C4541414D6E4A2C5541415577442C4F4141532C574143';
wwv_flow_api.g_varchar2_table(331) := '72422C47414132422C4F414176427A462C4B41414B79532C6341434C2C4B41414D2C4941414937522C4F41414D6D512C4F41474F69422C4B4141764268532C4B41414B79532C6541494A7A532C4B41414B79532C6341416372452C59414B7842704F2C4B';
wwv_flow_api.g_varchar2_table(332) := '41414B79532C6341416372452C5741415733492C5541476C4332462C4541414D6E4A2C5541415530512C514141552C57414374422C47414132422C4F4141764233532C4B41414B79532C6341434C2C4B41414D2C4941414937522C4F41414D6D512C4541';
wwv_flow_api.g_varchar2_table(333) := '4770422F512C4D41414B32452C4F41434C33452C4B41414B304D2C494141496B472C57414157432C5941415937532C4B41414B304D2C4B41437243314D2C4B41414B304D2C4941414D2C4B414358314D2C4B41414B364E2C4B41414F2C4B41435A374E2C';
wwv_flow_api.g_varchar2_table(334) := '4B41414B75532C4D4141512C4B41436276532C4B41414B79532C63414167422C4B4145482C4F4141647A532C4B41414B79512C4F41434C7A512C4B41414B79512C4B41414B6D432C57414157432C5941415937532C4B41414B79512C4D414374437A512C';
wwv_flow_api.g_varchar2_table(335) := '4B41414B79512C4B41414F2C4F4149704272462C4541414D6E4A2C554141552B482C4941414D2C5341416130452C4741432F422C47414132422C4F41417642314F2C4B41414B79532C6341434C2C4B41414D2C4941414937522C4F41414D6D512C454147';
wwv_flow_api.g_varchar2_table(336) := '70422F512C4D41414B79532C634141637A492C4941414930452C494147334274442C4541414D6E4A2C554141554C2C4D4141512C57414370422C47414132422C4F4141764235422C4B41414B79532C6341434C2C4B41414D2C4941414937522C4F41414D';
wwv_flow_api.g_varchar2_table(337) := '6D512C45414770422C594141324269422C4B4141764268532C4B41414B79532C634143452C4541474A7A532C4B41414B79532C6341416337512C5341473942774A2C4541414D6E4A2C5541415579512C514141552C5341416942492C47414376432C4741';
wwv_flow_api.g_varchar2_table(338) := '4132422C4F4141764239532C4B41414B79532C6341434C2C4B41414D2C4941414937522C4F41414D6D512C454147462C514141642F512C4B41414B79512C4F41454C7A512C4B41414B79512C4B41414F7A512C4B41414B2B532C7142414171422F532C4B';
wwv_flow_api.g_varchar2_table(339) := '41414B6D4F2C4D41414F6E4F2C4B41414B6D532C59414376446E532C4B41414B6D532C57414157432C5941415970532C4B41414B79512C4F41496A4370462C4541414D30472C53414153652C494143667A482C4541414D32482C6541416568542C4B4141';
wwv_flow_api.g_varchar2_table(340) := '4B79512C4D414331427A512C4B41414B79512C4B41414B32422C59414159552C494145744239532C4B41414B79512C4B41414B77432C55414159482C474149394231482C4541414D6E4A2C5541415569512C65414169422C534141774274472C47414372';
wwv_flow_api.g_varchar2_table(341) := '442C47414149632C4741414D75422C5341415369462C6742414167422C3642414138422C4D41436A456C542C4D41414B794D2C65414165432C4541414B642C4541457A422C4941414975482C474141592C4D41475A76482C4541414B71462C5941416372';
wwv_flow_api.g_varchar2_table(342) := '462C4541414B472C63414378426F482C454141596E542C4B41414B6F542C6141416178482C4741433942632C4541414930462C59414159652C47414770422C4941414974462C4741414F374E2C4B41414B71542C594141597A482C45414735422C4F4146';
wwv_flow_api.g_varchar2_table(343) := '41632C4741414930462C5941415976452C4941475A6E422C4941414B412C4541434C6D422C4B41414D412C4541434E30452C4D41414F592C494149662F482C4541414D6E4A2C55414155774B2C65414169422C5341417742432C4541414B642C47414331';
wwv_flow_api.g_varchar2_table(344) := '44632C45414149452C614141612C554141572C67424147684378422C4541414D6E4A2C554141556F522C594141632C53414171427A482C4741432F432C4741414930482C4741416174542C4B41414B324C2C59414159432C4541436C432C4F41414F354C';
wwv_flow_api.g_varchar2_table(345) := '2C4D41414B75542C6D4241416D42442C4541415931482C4941472F43522C4541414D6E4A2C554141556D522C614141652C534141734278482C4741456A442C4741414930482C4741416174542C4B41414B6D4D2C61414161502C4741472F4234472C4541';
wwv_flow_api.g_varchar2_table(346) := '41556E482C4541414D79432C554141576C432C454169422F422C4F41644B34472C4741415176422C6141435475422C4541415176422C574141612C514145704275422C454141517A472C6141435479472C454141517A472C5741416179472C4541415131';
wwv_flow_api.g_varchar2_table(347) := '472C6141476A4330472C4541415178422C4D41415177422C4541415176422C574143784275422C4541415131472C5941416330472C454141517A472C574149394279472C4541415174422C4B41414F2C4B4145526C522C4B41414B75542C6D4241416D42';
wwv_flow_api.g_varchar2_table(348) := '442C45414159642C4941472F4370482C4541414D6E4A2C5541415573522C6D42414171422C5341413442442C4541415931482C4741437A452C4741414969432C4741414F492C5341415369462C6742414167422C3642414138422C4F41576C452C4F4156';
wwv_flow_api.g_varchar2_table(349) := '4172462C4741414B6A422C614141612C4941414B30472C47414376427A462C4541414B6A422C614141612C5341415568422C4541414B6F462C4F41436A436E442C4541414B6A422C614141612C654141674268422C4541414B452C6141456E43462C4541';
wwv_flow_api.g_varchar2_table(350) := '414B73462C4B41434C72442C4541414B6A422C614141612C4F41415168422C4541414B73462C4D41452F4272442C4541414B6A422C614141612C65414167422C4B41472F4269422C474147587A432C4541414D6E4A2C5541415538512C7142414175422C';
wwv_flow_api.g_varchar2_table(351) := '53414138426E482C4541414D4C2C47414376452C4741414969462C474141674276432C5341415375462C634141632C4D4143334368442C474141636B422C5541415939462C4541414B36452C4B41414B69422C53414570432C494141492B422C47414159';
wwv_flow_api.g_varchar2_table(352) := '37482C4541414B36452C4B41414B6E432C4B416331422C4F4162496D462C4B41434937482C4541414B36452C4B41414B67422C71424143566C472C454141552B432C4D41414D36432C534141572C5941472F4239462C4541414D69482C5541415539422C';
wwv_flow_api.g_varchar2_table(353) := '4541416569442C4741453142412C454141557A432C51414358522C454141636C432C4D41414D30432C4D41415170462C4541414B6F462C5141497A4368522C4B41414B75512C79424141794233452C4541414D4C2C4541415769462C4741437843412C47';
wwv_flow_api.g_varchar2_table(354) := '41495870462C4541414D6E4A2C55414155734F2C7942414132422C5341415333452C4541414D4C2C4541415777432C4B414B724533432C4541414D6E4A2C55414155304A2C594141632C5341417142432C4741432F432C4B41414D2C49414149684C2C4F';
wwv_flow_api.g_varchar2_table(355) := '41414D2C694441477042774B2C4541414D6E4A2C554141556B4B2C614141652C5341417342502C4741436A442C4B41414D2C49414149684C2C4F41414D2C694441477042774B2C4541414D6E4A2C554141556F512C3042414134422C5341416D4339472C';
wwv_flow_api.g_varchar2_table(356) := '47414333452C4741414B764C2C4B41414B304C2C71424141562C434149412C4741414975452C474141674270512C4F41414F71512C69424141694233452C454141572C4D41436E4473472C454141516C442C5741415773422C45414163452C6942414169';

wwv_flow_api.g_varchar2_table(357) := '422C534141552C494143354475442C454141532F452C5741415773422C45414163452C6942414169422C554141572C474143374439452C4741414D73492C5941415933542C4B41414B304C2C7142414173426D472C4541415136422C4B4143744433442C';
wwv_flow_api.g_varchar2_table(358) := '5141415136442C4B41434A2C73434143412C4941414D72492C4541415573492C47414368422C5941434135442C45414163452C6942414169422C534141572C55414331432C49414341462C45414163452C6942414169422C554141592C57414333432C49';
wwv_flow_api.g_varchar2_table(359) := '41434130422C4541415136422C4741475A33442C5141415136442C4B41434A2C344241434135542C4B41414B304C2C7942414B6A426A4D2C4541414F442C51414155344C2C4941456467432C534141532C45414145662C554141552C4941414979482C47';
wwv_flow_api.g_varchar2_table(360) := '4141472C5341415372542C4541415168422C4541414F442C47414D76442C47414149344C2C47414151334B2C454141512C5741436842344B2C45414151354B2C454141512C5741456842754D2C454141532C53414167427A422C45414157432C47414370';
wwv_flow_api.g_varchar2_table(361) := '43784C2C4B41414B794C2C634143442C3449414D4A7A4C2C4B41414B2B542C654143442C384A414D4A33492C4541414D74492C4D41414D39432C4B41414D2B432C5741477442694B2C4741414F2F4B2C554141592C474141496D4A2C474143764234422C';
wwv_flow_api.g_varchar2_table(362) := '4541414F2F4B2C554141554F2C59414163774B2C4541452F42412C4541414F2F4B2C55414155304A2C594141632C5341417142432C47414368442C474141497A492C474141492C4941414D79492C4541414B452C594141632C4341456A432C4F41414F54';
wwv_flow_api.g_varchar2_table(363) := '2C4741414D572C4F41414F684D2C4B41414B794C2C65414372426F472C4D41414F314F2C4541435032492C59414161462C4541414B452C5941436C426B492C6B4241416D4270492C4541414B452C594141632C4B414939436B422C4541414F2F4B2C5541';
wwv_flow_api.g_varchar2_table(364) := '41556B4B2C614141652C5341417342502C4741436C442C474141497A492C474141492C4941414D79492C4541414B452C594141632C4341456A432C4F41414F542C4741414D572C4F41414F684D2C4B41414B2B542C6742414372426C432C4D41414F314F';
wwv_flow_api.g_varchar2_table(365) := '2C4541435032492C59414161462C4541414B452C5941436C426B492C6B4241416D4270492C4541414B452C594141632C45414374436D492C5941416172492C4541414B452C594141632C45414149462C4541414B472C574141612C4B41493944744D2C45';
wwv_flow_api.g_varchar2_table(366) := '41414F442C51414155774E2C494145645A2C554141552C45414145432C554141552C4941414936482C474141472C534141537A542C4541415168422C4541414F442C47415178442C51414153734F2C4741414F71472C454141616E4C2C454141516F4C2C';
wwv_flow_api.g_varchar2_table(367) := '4741436A43442C45414163412C4D4143646E4C2C45414153412C4D4143546F4C2C45414159412C494141612C4341457A422C4B41414B2C47414149432C4B414159724C2C4741436A422C47414149412C4541414F39472C654141656D532C474141572C43';
wwv_flow_api.g_varchar2_table(368) := '41436A432C47414149432C47414155482C45414159452C4741437442452C45414159764C2C4541414F714C2C4541436E42442C4941416172432C4541415375432C4941415976432C4541415377432C47414333434A2C45414159452C4741415976472C45';
wwv_flow_api.g_varchar2_table(369) := '41414F77472C45414153432C45414157482C4741456E44442C45414159452C47414159452C45414B70432C4D41414F4A2C474151582C514141536E492C4741414F77492C45414155432C47414374422C47414149432C47414157462C434145662C4B4141';
wwv_flow_api.g_varchar2_table(370) := '4B2C474141496C532C4B41414F6D532C4741435A2C47414149412C4541414B76532C65414165492C4741414D2C43414331422C4741414971532C4741414D462C4541414B6E532C4741435873532C454141652C4D41415174532C4541414D2C4D41433742';
wwv_flow_api.g_varchar2_table(371) := '75532C454141532C47414149354C2C5141414F324C2C454141632C4941457443462C47414157412C45414153744C2C51414151794C2C45414151462C47414935432C4D41414F442C474147582C5141415337442C4741415339432C454141534F2C454141';
wwv_flow_api.g_varchar2_table(372) := '4F314D2C47414739422C4941414B2C474146446B542C474141552F472C454141514F2C4D4145622F4E2C454141492C45414147412C4541414977552C454141532F542C53414155542C454141472C434145744375552C45414461432C4541415378552C47';
wwv_flow_api.g_varchar2_table(373) := '41434C79552C4541415731472C49414155314D2C45414731436B542C4541415178472C47414153314D2C45414772422C5141415330512C4741415576452C454141536B482C4741437842432C45414163442C454141512C53414153452C45414159432C47';
wwv_flow_api.g_varchar2_table(374) := '414770422C4F414166442C4F414173436E442C4B4141666D442C49414D764270442C454141536F442C4B414171432C4941417442412C4541415733442C4F41436E43582C4541415339432C4541415371482C45414157442C4541415776542C4F41457843';
wwv_flow_api.g_varchar2_table(375) := '6D4D2C454141514F2C4D41414D38472C47414161442C4B414B76432C51414153482C4741415776452C47414368422C4D41414F412C4741414B39472C4F41414F2C47414147304C2C634141674235452C4541414B36452C4D41414D2C47414772442C5141';
wwv_flow_api.g_varchar2_table(376) := '415374482C4741415375482C474143642C4D414173422C6742414152412C4941416F42412C59414165432C51414772442C5141415331472C4741415779472C47414368422C4D414173422C6B42414152412C4741476C422C51414153354D2C4741415134';
wwv_flow_api.g_varchar2_table(377) := '4D2C474143622C4D41412B432C6D42414178436A552C4F41414F572C5541415532472C5341415337482C4B41414B77552C47414B31432C5141415378442C4741415377442C474143642C4F414149354D2C45414151344D2C4B414B492C6742414445412C';
wwv_flow_api.g_varchar2_table(378) := '4D414359412C4741476C432C514141534C2C474141634F2C45414151432C47414333422C4941414B2C4741414970542C4B41414F6D542C4741435A2C47414149412C4541414F76542C65414165492C4741414D2C43414335422C4741414971532C474141';
wwv_flow_api.g_varchar2_table(379) := '4D632C4541414F6E542C4541436A426F542C47414153662C4541414B72532C49414B31422C5141415371522C4741415968542C4541414779432C47414370422C4D41414F79442C4D41414B384F2C4941414968562C4541414979432C4741414B77532C45';
wwv_flow_api.g_varchar2_table(380) := '414937422C5141415335432C4741416536432C47414370422C4B41414F412C45414147432C5941434E442C4541414768442C5941415967442C45414147432C5941744831422C47414149662C474141572C6B4241416B42314C2C4D41414D2C4B41436E43';
wwv_flow_api.g_varchar2_table(381) := '754D2C45414132422C494179482F426E572C4741414F442C53414348734F2C4F414151412C4541435239422C4F414151412C4541435236452C53414155412C4541435679422C55414157412C4541435830432C57414159412C4541435A68482C53414155';
wwv_flow_api.g_varchar2_table(382) := '412C45414356632C57414159412C4541435A69442C53414155412C454143566D442C63414165412C4541436676422C59414161412C45414362582C6541416742412C614147542C49414149222C2266696C65223A2270726F67726573736261722E6D696E';
wwv_flow_api.g_varchar2_table(383) := '2E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(217719718373218314)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_file_name=>'progressbarjs/js/progressbar.min.js.map'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E2861297B696628226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C65296D6F64756C652E6578706F7274733D6128293B656C7365206966282266756E';
wwv_flow_api.g_varchar2_table(2) := '6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D6429646566696E65285B5D2C61293B656C73657B76617220623B623D22756E646566696E656422213D747970656F662077696E646F773F77696E646F773A22756E646566';
wwv_flow_api.g_varchar2_table(3) := '696E656422213D747970656F6620676C6F62616C3F676C6F62616C3A22756E646566696E656422213D747970656F662073656C663F73656C663A746869732C622E50726F67726573734261723D6128297D7D2866756E6374696F6E28297B76617220613B';
wwv_flow_api.g_varchar2_table(4) := '72657475726E2066756E6374696F6E28297B66756E6374696F6E206128622C632C64297B66756E6374696F6E206528672C68297B69662821635B675D297B69662821625B675D297B76617220693D2266756E6374696F6E223D3D747970656F6620726571';
wwv_flow_api.g_varchar2_table(5) := '756972652626726571756972653B69662821682626692972657475726E206928672C2130293B696628662972657475726E206628672C2130293B766172206A3D6E6577204572726F72282243616E6E6F742066696E64206D6F64756C652027222B672B22';
wwv_flow_api.g_varchar2_table(6) := '2722293B7468726F77206A2E636F64653D224D4F44554C455F4E4F545F464F554E44222C6A7D766172206B3D635B675D3D7B6578706F7274733A7B7D7D3B625B675D5B305D2E63616C6C286B2E6578706F7274732C66756E6374696F6E2861297B726574';
wwv_flow_api.g_varchar2_table(7) := '75726E206528625B675D5B315D5B615D7C7C61297D2C6B2C6B2E6578706F7274732C612C622C632C64297D72657475726E20635B675D2E6578706F7274737D666F722876617220663D2266756E6374696F6E223D3D747970656F66207265717569726526';
wwv_flow_api.g_varchar2_table(8) := '26726571756972652C673D303B673C642E6C656E6774683B672B2B296528645B675D293B72657475726E20657D72657475726E20617D2829287B313A5B66756E6374696F6E28622C632C64297B2166756E6374696F6E28622C65297B226F626A65637422';
wwv_flow_api.g_varchar2_table(9) := '3D3D747970656F6620642626226F626A656374223D3D747970656F6620633F632E6578706F7274733D6528293A2266756E6374696F6E223D3D747970656F6620612626612E616D643F612822736869667479222C5B5D2C65293A226F626A656374223D3D';
wwv_flow_api.g_varchar2_table(10) := '747970656F6620643F642E7368696674793D6528293A622E7368696674793D6528297D2877696E646F772C66756E6374696F6E28297B72657475726E2066756E6374696F6E2861297B66756E6374696F6E20622864297B696628635B645D297265747572';
wwv_flow_api.g_varchar2_table(11) := '6E20635B645D2E6578706F7274733B76617220653D635B645D3D7B693A642C6C3A21312C6578706F7274733A7B7D7D3B72657475726E20615B645D2E63616C6C28652E6578706F7274732C652C652E6578706F7274732C62292C652E6C3D21302C652E65';
wwv_flow_api.g_varchar2_table(12) := '78706F7274737D76617220633D7B7D3B72657475726E20622E6D3D612C622E633D632C622E643D66756E6374696F6E28612C632C64297B622E6F28612C63297C7C4F626A6563742E646566696E6550726F706572747928612C632C7B656E756D65726162';
wwv_flow_api.g_varchar2_table(13) := '6C653A21302C6765743A647D297D2C622E723D66756E6374696F6E2861297B22756E646566696E656422213D747970656F662053796D626F6C262653796D626F6C2E746F537472696E6754616726264F626A6563742E646566696E6550726F7065727479';
wwv_flow_api.g_varchar2_table(14) := '28612C53796D626F6C2E746F537472696E675461672C7B76616C75653A224D6F64756C65227D292C4F626A6563742E646566696E6550726F706572747928612C225F5F65734D6F64756C65222C7B76616C75653A21307D297D2C622E743D66756E637469';
wwv_flow_api.g_varchar2_table(15) := '6F6E28612C63297B696628312663262628613D62286129292C3826632972657475726E20613B6966283426632626226F626A656374223D3D747970656F6620612626612626612E5F5F65734D6F64756C652972657475726E20613B76617220643D4F626A';
wwv_flow_api.g_varchar2_table(16) := '6563742E637265617465286E756C6C293B696628622E722864292C4F626A6563742E646566696E6550726F706572747928642C2264656661756C74222C7B656E756D657261626C653A21302C76616C75653A617D292C322663262622737472696E672221';
wwv_flow_api.g_varchar2_table(17) := '3D747970656F66206129666F7228766172206520696E206129622E6428642C652C66756E6374696F6E2862297B72657475726E20615B625D7D2E62696E64286E756C6C2C6529293B72657475726E20647D2C622E6E3D66756E6374696F6E2861297B7661';
wwv_flow_api.g_varchar2_table(18) := '7220633D612626612E5F5F65734D6F64756C653F66756E6374696F6E28297B72657475726E20612E64656661756C747D3A66756E6374696F6E28297B72657475726E20617D3B72657475726E20622E6428632C2261222C63292C637D2C622E6F3D66756E';
wwv_flow_api.g_varchar2_table(19) := '6374696F6E28612C62297B72657475726E204F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C28612C62297D2C622E703D22222C6228622E733D33297D285B66756E6374696F6E28612C622C63297B2275736520';
wwv_flow_api.g_varchar2_table(20) := '737472696374223B2866756E6374696F6E2861297B66756E6374696F6E206428612C62297B666F722876617220633D303B633C622E6C656E6774683B632B2B297B76617220643D625B635D3B642E656E756D657261626C653D642E656E756D657261626C';
wwv_flow_api.g_varchar2_table(21) := '657C7C21312C642E636F6E666967757261626C653D21302C2276616C756522696E2064262628642E7772697461626C653D2130292C4F626A6563742E646566696E6550726F706572747928612C642E6B65792C64297D7D66756E6374696F6E2065286129';
wwv_flow_api.g_varchar2_table(22) := '7B72657475726E28653D2266756E6374696F6E223D3D747970656F662053796D626F6C26262273796D626F6C223D3D747970656F662053796D626F6C2E6974657261746F723F66756E6374696F6E2861297B72657475726E20747970656F6620617D3A66';
wwv_flow_api.g_varchar2_table(23) := '756E6374696F6E2861297B72657475726E206126262266756E6374696F6E223D3D747970656F662053796D626F6C2626612E636F6E7374727563746F723D3D3D53796D626F6C262661213D3D53796D626F6C2E70726F746F747970653F2273796D626F6C';
wwv_flow_api.g_varchar2_table(24) := '223A747970656F6620617D292861297D66756E6374696F6E206628612C62297B76617220633D4F626A6563742E6B6579732861293B6966284F626A6563742E6765744F776E50726F706572747953796D626F6C73297B76617220643D4F626A6563742E67';
wwv_flow_api.g_varchar2_table(25) := '65744F776E50726F706572747953796D626F6C732861293B62262628643D642E66696C7465722866756E6374696F6E2862297B72657475726E204F626A6563742E6765744F776E50726F706572747944657363726970746F7228612C62292E656E756D65';
wwv_flow_api.g_varchar2_table(26) := '7261626C657D29292C632E707573682E6170706C7928632C64297D72657475726E20637D66756E6374696F6E20672861297B666F722876617220623D313B623C617267756D656E74732E6C656E6774683B622B2B297B76617220633D6E756C6C213D6172';
wwv_flow_api.g_varchar2_table(27) := '67756D656E74735B625D3F617267756D656E74735B625D3A7B7D3B6225323F66284F626A6563742863292C2130292E666F72456163682866756E6374696F6E2862297B6828612C622C635B625D297D293A4F626A6563742E6765744F776E50726F706572';
wwv_flow_api.g_varchar2_table(28) := '747944657363726970746F72733F4F626A6563742E646566696E6550726F7065727469657328612C4F626A6563742E6765744F776E50726F706572747944657363726970746F7273286329293A66284F626A656374286329292E666F7245616368286675';
wwv_flow_api.g_varchar2_table(29) := '6E6374696F6E2862297B4F626A6563742E646566696E6550726F706572747928612C622C4F626A6563742E6765744F776E50726F706572747944657363726970746F7228632C6229297D297D72657475726E20617D66756E6374696F6E206828612C622C';
wwv_flow_api.g_varchar2_table(30) := '63297B72657475726E206220696E20613F4F626A6563742E646566696E6550726F706572747928612C622C7B76616C75653A632C656E756D657261626C653A21302C636F6E666967757261626C653A21302C7772697461626C653A21307D293A615B625D';
wwv_flow_api.g_varchar2_table(31) := '3D632C617D66756E6374696F6E206928297B76617220613D617267756D656E74732E6C656E6774683E302626766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B305D3A7B7D2C623D6E657720762C633D622E747765656E28';
wwv_flow_api.g_varchar2_table(32) := '61293B72657475726E20632E747765656E61626C653D622C637D632E6428622C2265222C66756E6374696F6E28297B72657475726E20717D292C632E6428622C2263222C66756E6374696F6E28297B72657475726E20737D292C632E6428622C2262222C';
wwv_flow_api.g_varchar2_table(33) := '66756E6374696F6E28297B72657475726E20747D292C632E6428622C2261222C66756E6374696F6E28297B72657475726E20767D292C632E6428622C2264222C66756E6374696F6E28297B72657475726E20697D293B766172206A3D632831292C6B3D22';
wwv_flow_api.g_varchar2_table(34) := '756E646566696E656422213D747970656F662077696E646F773F77696E646F773A612C6C3D6B2E72657175657374416E696D6174696F6E4672616D657C7C6B2E7765626B697452657175657374416E696D6174696F6E4672616D657C7C6B2E6F52657175';
wwv_flow_api.g_varchar2_table(35) := '657374416E696D6174696F6E4672616D657C7C6B2E6D7352657175657374416E696D6174696F6E4672616D657C7C6B2E6D6F7A43616E63656C52657175657374416E696D6174696F6E4672616D6526266B2E6D6F7A52657175657374416E696D6174696F';
wwv_flow_api.g_varchar2_table(36) := '6E4672616D657C7C73657454696D656F75742C6D3D66756E6374696F6E28297B7D2C6E3D6E756C6C2C6F3D6E756C6C2C703D67287B7D2C6A292C713D66756E6374696F6E28612C622C632C642C652C662C67297B76617220683D613C663F303A28612D66';
wwv_flow_api.g_varchar2_table(37) := '292F653B666F7228766172206920696E2062297B766172206A3D675B695D2C6B3D6A2E63616C6C3F6A3A705B6A5D2C6C3D635B695D3B625B695D3D6C2B28645B695D2D6C292A6B2868297D72657475726E20627D2C723D66756E6374696F6E28612C6229';
wwv_flow_api.g_varchar2_table(38) := '7B76617220633D612E5F6174746163686D656E742C643D612E5F63757272656E7453746174652C653D612E5F64656C61792C663D612E5F656173696E672C673D612E5F6F726967696E616C53746174652C683D612E5F6475726174696F6E2C693D612E5F';
wwv_flow_api.g_varchar2_table(39) := '737465702C6A3D612E5F74617267657453746174652C6B3D612E5F74696D657374616D702C6C3D6B2B652B682C6D3D623E6C3F6C3A622C6E3D682D286C2D6D293B6D3E3D6C3F2869286A2C632C6E292C612E73746F7028213029293A28612E5F6170706C';
wwv_flow_api.g_varchar2_table(40) := '7946696C74657228226265666F7265547765656E22292C6D3C6B2B653F286D3D312C683D312C6B3D31293A6B2B3D652C71286D2C642C672C6A2C682C6B2C66292C612E5F6170706C7946696C74657228226166746572547765656E22292C6928642C632C';
wwv_flow_api.g_varchar2_table(41) := '6E29297D2C733D66756E6374696F6E28297B666F722876617220613D762E6E6F7728292C623D6E3B623B297B76617220633D622E5F6E6578743B7228622C61292C623D637D7D2C743D66756E6374696F6E2861297B76617220623D617267756D656E7473';
wwv_flow_api.g_varchar2_table(42) := '2E6C656E6774683E312626766F69642030213D3D617267756D656E74735B315D3F617267756D656E74735B315D3A226C696E656172222C633D7B7D2C643D652862293B69662822737472696E67223D3D3D647C7C2266756E6374696F6E223D3D3D642966';
wwv_flow_api.g_varchar2_table(43) := '6F7228766172206620696E206129635B665D3D623B656C736520666F7228766172206720696E206129635B675D3D625B675D7C7C226C696E656172223B72657475726E20637D2C753D66756E6374696F6E2861297B696628613D3D3D6E29286E3D612E5F';
wwv_flow_api.g_varchar2_table(44) := '6E657874293F6E2E5F70726576696F75733D6E756C6C3A6F3D6E756C6C3B656C736520696628613D3D3D6F29286F3D612E5F70726576696F7573293F6F2E5F6E6578743D6E756C6C3A6E3D6E756C6C3B656C73657B76617220623D612E5F70726576696F';
wwv_flow_api.g_varchar2_table(45) := '75732C633D612E5F6E6578743B622E5F6E6578743D632C632E5F70726576696F75733D627D612E5F70726576696F75733D612E5F6E6578743D6E756C6C7D2C763D66756E6374696F6E28297B66756E6374696F6E206128297B76617220623D617267756D';
wwv_flow_api.g_varchar2_table(46) := '656E74732E6C656E6774683E302626766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B305D3A7B7D2C633D617267756D656E74732E6C656E6774683E312626766F69642030213D3D617267756D656E74735B315D3F617267';
wwv_flow_api.g_varchar2_table(47) := '756D656E74735B315D3A766F696420303B2166756E6374696F6E28612C62297B69662821286120696E7374616E63656F66206229297468726F77206E657720547970654572726F72282243616E6E6F742063616C6C206120636C61737320617320612066';
wwv_flow_api.g_varchar2_table(48) := '756E6374696F6E22297D28746869732C61292C746869732E5F63757272656E7453746174653D622C746869732E5F636F6E666967757265643D21312C746869732E5F66696C746572733D5B5D2C746869732E5F74696D657374616D703D6E756C6C2C7468';
wwv_flow_api.g_varchar2_table(49) := '69732E5F6E6578743D6E756C6C2C746869732E5F70726576696F75733D6E756C6C2C632626746869732E736574436F6E6669672863297D76617220622C632C653B72657475726E20623D612C28633D5B7B6B65793A225F6170706C7946696C746572222C';
wwv_flow_api.g_varchar2_table(50) := '76616C75653A66756E6374696F6E2861297B76617220623D21302C633D21312C643D766F696420303B7472797B666F722876617220652C663D746869732E5F66696C746572735B53796D626F6C2E6974657261746F725D28293B2128623D28653D662E6E';
wwv_flow_api.g_varchar2_table(51) := '6578742829292E646F6E65293B623D2130297B76617220673D652E76616C75655B615D3B672626672874686973297D7D63617463682861297B633D21302C643D617D66696E616C6C797B7472797B627C7C6E756C6C3D3D662E72657475726E7C7C662E72';
wwv_flow_api.g_varchar2_table(52) := '657475726E28297D66696E616C6C797B69662863297468726F7720647D7D7D7D2C7B6B65793A22747765656E222C76616C75653A66756E6374696F6E28297B76617220623D617267756D656E74732E6C656E6774683E302626766F69642030213D3D6172';
wwv_flow_api.g_varchar2_table(53) := '67756D656E74735B305D3F617267756D656E74735B305D3A766F696420302C633D746869732E5F6174746163686D656E742C643D746869732E5F636F6E666967757265643B72657475726E21622626647C7C746869732E736574436F6E6669672862292C';
wwv_flow_api.g_varchar2_table(54) := '746869732E5F706175736564417454696D653D6E756C6C2C746869732E5F74696D657374616D703D612E6E6F7728292C746869732E5F737461727428746869732E67657428292C63292C746869732E726573756D6528297D7D2C7B6B65793A2273657443';
wwv_flow_api.g_varchar2_table(55) := '6F6E666967222C76616C75653A66756E6374696F6E28297B76617220623D746869732C633D617267756D656E74732E6C656E6774683E302626766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B305D3A7B7D2C643D632E61';
wwv_flow_api.g_varchar2_table(56) := '74746163686D656E742C653D632E64656C61792C663D766F696420303D3D3D653F303A652C683D632E6475726174696F6E2C693D766F696420303D3D3D683F3530303A682C6A3D632E656173696E672C6B3D632E66726F6D2C6C3D632E70726F6D697365';
wwv_flow_api.g_varchar2_table(57) := '2C6E3D766F696420303D3D3D6C3F50726F6D6973653A6C2C6F3D632E73746172742C703D766F696420303D3D3D6F3F6D3A6F2C713D632E737465702C723D766F696420303D3D3D713F6D3A712C733D632E746F3B746869732E5F636F6E66696775726564';
wwv_flow_api.g_varchar2_table(58) := '3D21302C746869732E5F6174746163686D656E743D642C746869732E5F6973506C6179696E673D21312C746869732E5F706175736564417454696D653D6E756C6C2C746869732E5F7363686564756C6549643D6E756C6C2C746869732E5F64656C61793D';
wwv_flow_api.g_varchar2_table(59) := '662C746869732E5F73746172743D702C746869732E5F737465703D722C746869732E5F6475726174696F6E3D692C746869732E5F63757272656E7453746174653D67287B7D2C6B7C7C746869732E6765742829292C746869732E5F6F726967696E616C53';
wwv_flow_api.g_varchar2_table(60) := '746174653D746869732E67657428292C746869732E5F74617267657453746174653D67287B7D2C737C7C746869732E6765742829293B76617220753D746869732E5F63757272656E7453746174653B746869732E5F74617267657453746174653D67287B';
wwv_flow_api.g_varchar2_table(61) := '7D2C752C7B7D2C746869732E5F7461726765745374617465292C746869732E5F656173696E673D7428752C6A293B76617220763D612E66696C746572733B666F7228766172207720696E20746869732E5F66696C746572732E6C656E6774683D302C7629';
wwv_flow_api.g_varchar2_table(62) := '765B775D2E646F65734170706C792874686973292626746869732E5F66696C746572732E7075736828765B775D293B72657475726E20746869732E5F6170706C7946696C7465722822747765656E4372656174656422292C746869732E5F70726F6D6973';
wwv_flow_api.g_varchar2_table(63) := '653D6E6577206E2866756E6374696F6E28612C63297B622E5F7265736F6C76653D612C622E5F72656A6563743D637D292C746869732E5F70726F6D6973652E6361746368286D292C746869737D7D2C7B6B65793A22676574222C76616C75653A66756E63';
wwv_flow_api.g_varchar2_table(64) := '74696F6E28297B72657475726E2067287B7D2C746869732E5F63757272656E745374617465297D7D2C7B6B65793A22736574222C76616C75653A66756E6374696F6E2861297B746869732E5F63757272656E7453746174653D617D7D2C7B6B65793A2270';
wwv_flow_api.g_varchar2_table(65) := '61757365222C76616C75653A66756E6374696F6E28297B696628746869732E5F6973506C6179696E672972657475726E20746869732E5F706175736564417454696D653D612E6E6F7728292C746869732E5F6973506C6179696E673D21312C7528746869';
wwv_flow_api.g_varchar2_table(66) := '73292C746869737D7D2C7B6B65793A22726573756D65222C76616C75653A66756E6374696F6E28297B6966286E756C6C3D3D3D746869732E5F74696D657374616D702972657475726E20746869732E747765656E28293B696628746869732E5F6973506C';
wwv_flow_api.g_varchar2_table(67) := '6179696E672972657475726E20746869732E5F70726F6D6973653B76617220623D612E6E6F7728293B72657475726E20746869732E5F706175736564417454696D65262628746869732E5F74696D657374616D702B3D622D746869732E5F706175736564';
wwv_flow_api.g_varchar2_table(68) := '417454696D652C746869732E5F706175736564417454696D653D6E756C6C292C746869732E5F6973506C6179696E673D21302C6E756C6C3D3D3D6E3F286E3D746869732C6F3D746869732C66756E6374696F6E206128297B6E2626286C2E63616C6C286B';
wwv_flow_api.g_varchar2_table(69) := '2C612C3165332F3630292C732829297D2829293A28746869732E5F70726576696F75733D6F2C6F2E5F6E6578743D746869732C6F3D74686973292C746869732E5F70726F6D6973657D7D2C7B6B65793A227365656B222C76616C75653A66756E6374696F';
wwv_flow_api.g_varchar2_table(70) := '6E2862297B623D4D6174682E6D617828622C30293B76617220633D612E6E6F7728293B72657475726E20746869732E5F74696D657374616D702B623D3D3D303F746869733A28746869732E5F74696D657374616D703D632D622C746869732E5F6973506C';
wwv_flow_api.g_varchar2_table(71) := '6179696E677C7C7228746869732C63292C74686973297D7D2C7B6B65793A2273746F70222C76616C75653A66756E6374696F6E28297B76617220613D617267756D656E74732E6C656E6774683E302626766F69642030213D3D617267756D656E74735B30';
wwv_flow_api.g_varchar2_table(72) := '5D2626617267756D656E74735B305D2C623D746869732E5F6174746163686D656E742C633D746869732E5F63757272656E7453746174652C643D746869732E5F656173696E672C653D746869732E5F6F726967696E616C53746174652C663D746869732E';
wwv_flow_api.g_varchar2_table(73) := '5F74617267657453746174653B696628746869732E5F6973506C6179696E672972657475726E20746869732E5F6973506C6179696E673D21312C752874686973292C613F28746869732E5F6170706C7946696C74657228226265666F7265547765656E22';
wwv_flow_api.g_varchar2_table(74) := '292C7128312C632C652C662C312C302C64292C746869732E5F6170706C7946696C74657228226166746572547765656E22292C746869732E5F6170706C7946696C74657228226166746572547765656E456E6422292C746869732E5F7265736F6C766528';
wwv_flow_api.g_varchar2_table(75) := '632C6229293A746869732E5F72656A65637428632C62292C746869737D7D2C7B6B65793A226973506C6179696E67222C76616C75653A66756E6374696F6E28297B72657475726E20746869732E5F6973506C6179696E677D7D2C7B6B65793A2273657453';
wwv_flow_api.g_varchar2_table(76) := '63686564756C6546756E6374696F6E222C76616C75653A66756E6374696F6E2862297B612E7365745363686564756C6546756E6374696F6E2862297D7D2C7B6B65793A22646973706F7365222C76616C75653A66756E6374696F6E28297B666F72287661';
wwv_flow_api.g_varchar2_table(77) := '72206120696E20746869732964656C65746520746869735B615D7D7D5D2926266428622E70726F746F747970652C63292C6526266428622C65292C617D28293B762E7365745363686564756C6546756E6374696F6E3D66756E6374696F6E2861297B7265';
wwv_flow_api.g_varchar2_table(78) := '7475726E206C3D617D2C762E666F726D756C61733D702C762E66696C746572733D7B7D2C762E6E6F773D446174652E6E6F777C7C66756E6374696F6E28297B72657475726E2B6E657720446174657D7D292E63616C6C28746869732C63283229297D2C66';
wwv_flow_api.g_varchar2_table(79) := '756E6374696F6E28612C622C63297B2275736520737472696374223B632E722862292C632E6428622C226C696E656172222C66756E6374696F6E28297B72657475726E20647D292C632E6428622C2265617365496E51756164222C66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(80) := '297B72657475726E20657D292C632E6428622C22656173654F757451756164222C66756E6374696F6E28297B72657475726E20667D292C632E6428622C2265617365496E4F757451756164222C66756E6374696F6E28297B72657475726E20677D292C63';
wwv_flow_api.g_varchar2_table(81) := '2E6428622C2265617365496E4375626963222C66756E6374696F6E28297B72657475726E20687D292C632E6428622C22656173654F75744375626963222C66756E6374696F6E28297B72657475726E20697D292C632E6428622C2265617365496E4F7574';
wwv_flow_api.g_varchar2_table(82) := '4375626963222C66756E6374696F6E28297B72657475726E206A7D292C632E6428622C2265617365496E5175617274222C66756E6374696F6E28297B72657475726E206B7D292C632E6428622C22656173654F75745175617274222C66756E6374696F6E';
wwv_flow_api.g_varchar2_table(83) := '28297B72657475726E206C7D292C632E6428622C2265617365496E4F75745175617274222C66756E6374696F6E28297B72657475726E206D7D292C632E6428622C2265617365496E5175696E74222C66756E6374696F6E28297B72657475726E206E7D29';
wwv_flow_api.g_varchar2_table(84) := '2C632E6428622C22656173654F75745175696E74222C66756E6374696F6E28297B72657475726E206F7D292C632E6428622C2265617365496E4F75745175696E74222C66756E6374696F6E28297B72657475726E20707D292C632E6428622C2265617365';
wwv_flow_api.g_varchar2_table(85) := '496E53696E65222C66756E6374696F6E28297B72657475726E20717D292C632E6428622C22656173654F757453696E65222C66756E6374696F6E28297B72657475726E20727D292C632E6428622C2265617365496E4F757453696E65222C66756E637469';
wwv_flow_api.g_varchar2_table(86) := '6F6E28297B72657475726E20737D292C632E6428622C2265617365496E4578706F222C66756E6374696F6E28297B72657475726E20747D292C632E6428622C22656173654F75744578706F222C66756E6374696F6E28297B72657475726E20757D292C63';
wwv_flow_api.g_varchar2_table(87) := '2E6428622C2265617365496E4F75744578706F222C66756E6374696F6E28297B72657475726E20767D292C632E6428622C2265617365496E43697263222C66756E6374696F6E28297B72657475726E20777D292C632E6428622C22656173654F75744369';
wwv_flow_api.g_varchar2_table(88) := '7263222C66756E6374696F6E28297B72657475726E20787D292C632E6428622C2265617365496E4F757443697263222C66756E6374696F6E28297B72657475726E20797D292C632E6428622C22656173654F7574426F756E6365222C66756E6374696F6E';
wwv_flow_api.g_varchar2_table(89) := '28297B72657475726E207A7D292C632E6428622C2265617365496E4261636B222C66756E6374696F6E28297B72657475726E20417D292C632E6428622C22656173654F75744261636B222C66756E6374696F6E28297B72657475726E20427D292C632E64';
wwv_flow_api.g_varchar2_table(90) := '28622C2265617365496E4F75744261636B222C66756E6374696F6E28297B72657475726E20437D292C632E6428622C22656C6173746963222C66756E6374696F6E28297B72657475726E20447D292C632E6428622C227377696E6746726F6D546F222C66';
wwv_flow_api.g_varchar2_table(91) := '756E6374696F6E28297B72657475726E20457D292C632E6428622C227377696E6746726F6D222C66756E6374696F6E28297B72657475726E20467D292C632E6428622C227377696E67546F222C66756E6374696F6E28297B72657475726E20477D292C63';
wwv_flow_api.g_varchar2_table(92) := '2E6428622C22626F756E6365222C66756E6374696F6E28297B72657475726E20487D292C632E6428622C22626F756E636550617374222C66756E6374696F6E28297B72657475726E20497D292C632E6428622C226561736546726F6D546F222C66756E63';
wwv_flow_api.g_varchar2_table(93) := '74696F6E28297B72657475726E204A7D292C632E6428622C226561736546726F6D222C66756E6374696F6E28297B72657475726E204B7D292C632E6428622C2265617365546F222C66756E6374696F6E28297B72657475726E204C7D293B76617220643D';
wwv_flow_api.g_varchar2_table(94) := '66756E6374696F6E2861297B72657475726E20617D2C653D66756E6374696F6E2861297B72657475726E204D6174682E706F7728612C32297D2C663D66756E6374696F6E2861297B72657475726E2D284D6174682E706F7728612D312C32292D31297D2C';
wwv_flow_api.g_varchar2_table(95) := '673D66756E6374696F6E2861297B72657475726E28612F3D2E35293C313F2E352A4D6174682E706F7728612C32293A2D2E352A2828612D3D32292A612D32297D2C683D66756E6374696F6E2861297B72657475726E204D6174682E706F7728612C33297D';
wwv_flow_api.g_varchar2_table(96) := '2C693D66756E6374696F6E2861297B72657475726E204D6174682E706F7728612D312C33292B317D2C6A3D66756E6374696F6E2861297B72657475726E28612F3D2E35293C313F2E352A4D6174682E706F7728612C33293A2E352A284D6174682E706F77';
wwv_flow_api.g_varchar2_table(97) := '28612D322C33292B32297D2C6B3D66756E6374696F6E2861297B72657475726E204D6174682E706F7728612C34297D2C6C3D66756E6374696F6E2861297B72657475726E2D284D6174682E706F7728612D312C34292D31297D2C6D3D66756E6374696F6E';

wwv_flow_api.g_varchar2_table(98) := '2861297B72657475726E28612F3D2E35293C313F2E352A4D6174682E706F7728612C34293A2D2E352A2828612D3D32292A4D6174682E706F7728612C33292D32297D2C6E3D66756E6374696F6E2861297B72657475726E204D6174682E706F7728612C35';
wwv_flow_api.g_varchar2_table(99) := '297D2C6F3D66756E6374696F6E2861297B72657475726E204D6174682E706F7728612D312C35292B317D2C703D66756E6374696F6E2861297B72657475726E28612F3D2E35293C313F2E352A4D6174682E706F7728612C35293A2E352A284D6174682E70';
wwv_flow_api.g_varchar2_table(100) := '6F7728612D322C35292B32297D2C713D66756E6374696F6E2861297B72657475726E20312D4D6174682E636F7328612A284D6174682E50492F3229297D2C723D66756E6374696F6E2861297B72657475726E204D6174682E73696E28612A284D6174682E';
wwv_flow_api.g_varchar2_table(101) := '50492F3229297D2C733D66756E6374696F6E2861297B72657475726E2D2E352A284D6174682E636F73284D6174682E50492A61292D31297D2C743D66756E6374696F6E2861297B72657475726E20303D3D3D613F303A4D6174682E706F7728322C31302A';
wwv_flow_api.g_varchar2_table(102) := '28612D3129297D2C753D66756E6374696F6E2861297B72657475726E20313D3D3D613F313A312D4D6174682E706F7728322C2D31302A61297D2C763D66756E6374696F6E2861297B72657475726E20303D3D3D613F303A313D3D3D613F313A28612F3D2E';
wwv_flow_api.g_varchar2_table(103) := '35293C313F2E352A4D6174682E706F7728322C31302A28612D3129293A2E352A28322D4D6174682E706F7728322C2D31302A2D2D6129297D2C773D66756E6374696F6E2861297B72657475726E2D284D6174682E7371727428312D612A61292D31297D2C';
wwv_flow_api.g_varchar2_table(104) := '783D66756E6374696F6E2861297B72657475726E204D6174682E7371727428312D4D6174682E706F7728612D312C3229297D2C793D66756E6374696F6E2861297B72657475726E28612F3D2E35293C313F2D2E352A284D6174682E7371727428312D612A';
wwv_flow_api.g_varchar2_table(105) := '61292D31293A2E352A284D6174682E7371727428312D28612D3D32292A61292B31297D2C7A3D66756E6374696F6E2861297B72657475726E20613C312F322E37353F372E353632352A612A613A613C322F322E37353F372E353632352A28612D3D312E35';
wwv_flow_api.g_varchar2_table(106) := '2F322E3735292A612B2E37353A613C322E352F322E37353F372E353632352A28612D3D322E32352F322E3735292A612B2E393337353A372E353632352A28612D3D322E3632352F322E3735292A612B2E3938343337357D2C413D66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(107) := '297B76617220623D312E37303135383B72657475726E20612A612A2828622B31292A612D62297D2C423D66756E6374696F6E2861297B76617220623D312E37303135383B72657475726E28612D3D31292A612A2828622B31292A612B62292B317D2C433D';
wwv_flow_api.g_varchar2_table(108) := '66756E6374696F6E2861297B76617220623D312E37303135383B72657475726E28612F3D2E35293C313F612A612A2828312B28622A3D312E35323529292A612D62292A2E353A2E352A2828612D3D32292A612A2828312B28622A3D312E35323529292A61';
wwv_flow_api.g_varchar2_table(109) := '2B62292B32297D2C443D66756E6374696F6E2861297B72657475726E2D312A4D6174682E706F7728342C2D382A61292A4D6174682E73696E2828362A612D31292A28322A4D6174682E5049292F32292B317D2C453D66756E6374696F6E2861297B766172';
wwv_flow_api.g_varchar2_table(110) := '20623D312E37303135383B72657475726E28612F3D2E35293C313F612A612A2828312B28622A3D312E35323529292A612D62292A2E353A2E352A2828612D3D32292A612A2828312B28622A3D312E35323529292A612B62292B32297D2C463D66756E6374';
wwv_flow_api.g_varchar2_table(111) := '696F6E2861297B76617220623D312E37303135383B72657475726E20612A612A2828622B31292A612D62297D2C473D66756E6374696F6E2861297B76617220623D312E37303135383B72657475726E28612D3D31292A612A2828622B31292A612B62292B';
wwv_flow_api.g_varchar2_table(112) := '317D2C483D66756E6374696F6E2861297B72657475726E20613C312F322E37353F372E353632352A612A613A613C322F322E37353F372E353632352A28612D3D312E352F322E3735292A612B2E37353A613C322E352F322E37353F372E353632352A2861';
wwv_flow_api.g_varchar2_table(113) := '2D3D322E32352F322E3735292A612B2E393337353A372E353632352A28612D3D322E3632352F322E3735292A612B2E3938343337357D2C493D66756E6374696F6E2861297B72657475726E20613C312F322E37353F372E353632352A612A613A613C322F';
wwv_flow_api.g_varchar2_table(114) := '322E37353F322D28372E353632352A28612D3D312E352F322E3735292A612B2E3735293A613C322E352F322E37353F322D28372E353632352A28612D3D322E32352F322E3735292A612B2E39333735293A322D28372E353632352A28612D3D322E363235';
wwv_flow_api.g_varchar2_table(115) := '2F322E3735292A612B2E393834333735297D2C4A3D66756E6374696F6E2861297B72657475726E28612F3D2E35293C313F2E352A4D6174682E706F7728612C34293A2D2E352A2828612D3D32292A4D6174682E706F7728612C33292D32297D2C4B3D6675';
wwv_flow_api.g_varchar2_table(116) := '6E6374696F6E2861297B72657475726E204D6174682E706F7728612C34297D2C4C3D66756E6374696F6E2861297B72657475726E204D6174682E706F7728612C2E3235297D7D2C66756E6374696F6E28612C62297B76617220633B633D66756E6374696F';
wwv_flow_api.g_varchar2_table(117) := '6E28297B72657475726E20746869737D28293B7472797B633D637C7C6E65772046756E6374696F6E282272657475726E2074686973222928297D63617463682861297B226F626A656374223D3D747970656F662077696E646F77262628633D77696E646F';
wwv_flow_api.g_varchar2_table(118) := '77297D612E6578706F7274733D637D2C66756E6374696F6E28612C622C63297B2275736520737472696374223B66756E6374696F6E20642861297B72657475726E207061727365496E7428612C3136297D66756E6374696F6E20652861297B7661722062';
wwv_flow_api.g_varchar2_table(119) := '3D612E5F63757272656E7453746174653B5B622C612E5F6F726967696E616C53746174652C612E5F74617267657453746174655D2E666F72456163682842292C612E5F746F6B656E446174613D452862297D66756E6374696F6E20662861297B76617220';
wwv_flow_api.g_varchar2_table(120) := '623D612E5F63757272656E7453746174652C633D612E5F6F726967696E616C53746174652C643D612E5F74617267657453746174652C653D612E5F656173696E672C663D612E5F746F6B656E446174613B4B28652C66292C5B622C632C645D2E666F7245';
wwv_flow_api.g_varchar2_table(121) := '6163682866756E6374696F6E2861297B72657475726E204628612C66297D297D66756E6374696F6E20672861297B76617220623D612E5F63757272656E7453746174652C633D612E5F6F726967696E616C53746174652C643D612E5F7461726765745374';
wwv_flow_api.g_varchar2_table(122) := '6174652C653D612E5F656173696E672C663D612E5F746F6B656E446174613B5B622C632C645D2E666F72456163682866756E6374696F6E2861297B72657475726E204A28612C66297D292C4C28652C66297D66756E6374696F6E206828612C62297B7661';
wwv_flow_api.g_varchar2_table(123) := '7220633D4F626A6563742E6B6579732861293B6966284F626A6563742E6765744F776E50726F706572747953796D626F6C73297B76617220643D4F626A6563742E6765744F776E50726F706572747953796D626F6C732861293B62262628643D642E6669';
wwv_flow_api.g_varchar2_table(124) := '6C7465722866756E6374696F6E2862297B72657475726E204F626A6563742E6765744F776E50726F706572747944657363726970746F7228612C62292E656E756D657261626C657D29292C632E707573682E6170706C7928632C64297D72657475726E20';
wwv_flow_api.g_varchar2_table(125) := '637D66756E6374696F6E20692861297B666F722876617220623D313B623C617267756D656E74732E6C656E6774683B622B2B297B76617220633D6E756C6C213D617267756D656E74735B625D3F617267756D656E74735B625D3A7B7D3B6225323F68284F';
wwv_flow_api.g_varchar2_table(126) := '626A6563742863292C2130292E666F72456163682866756E6374696F6E2862297B6A28612C622C635B625D297D293A4F626A6563742E6765744F776E50726F706572747944657363726970746F72733F4F626A6563742E646566696E6550726F70657274';
wwv_flow_api.g_varchar2_table(127) := '69657328612C4F626A6563742E6765744F776E50726F706572747944657363726970746F7273286329293A68284F626A656374286329292E666F72456163682866756E6374696F6E2862297B4F626A6563742E646566696E6550726F706572747928612C';
wwv_flow_api.g_varchar2_table(128) := '622C4F626A6563742E6765744F776E50726F706572747944657363726970746F7228632C6229297D297D72657475726E20617D66756E6374696F6E206A28612C622C63297B72657475726E206220696E20613F4F626A6563742E646566696E6550726F70';
wwv_flow_api.g_varchar2_table(129) := '6572747928612C622C7B76616C75653A632C656E756D657261626C653A21302C636F6E666967757261626C653A21302C7772697461626C653A21307D293A615B625D3D632C617D66756E6374696F6E206B2861297B72657475726E2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(130) := '2861297B69662841727261792E69734172726179286129297B666F722876617220623D302C633D6E657720417272617928612E6C656E677468293B623C612E6C656E6774683B622B2B29635B625D3D615B625D3B72657475726E20637D7D2861297C7C66';
wwv_flow_api.g_varchar2_table(131) := '756E6374696F6E2861297B69662853796D626F6C2E6974657261746F7220696E204F626A6563742861297C7C225B6F626A65637420417267756D656E74735D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C286129';
wwv_flow_api.g_varchar2_table(132) := '2972657475726E2041727261792E66726F6D2861297D2861297C7C66756E6374696F6E28297B7468726F77206E657720547970654572726F722822496E76616C696420617474656D707420746F20737072656164206E6F6E2D6974657261626C6520696E';
wwv_flow_api.g_varchar2_table(133) := '7374616E636522297D28297D66756E6374696F6E206C28612C62297B666F722876617220633D303B633C622E6C656E6774683B632B2B297B76617220643D625B635D3B642E656E756D657261626C653D642E656E756D657261626C657C7C21312C642E63';
wwv_flow_api.g_varchar2_table(134) := '6F6E666967757261626C653D21302C2276616C756522696E2064262628642E7772697461626C653D2130292C4F626A6563742E646566696E6550726F706572747928612C642E6B65792C64297D7D66756E6374696F6E206D28612C62297B76617220633D';
wwv_flow_api.g_varchar2_table(135) := '622E6765742861293B6966282163297468726F77206E657720547970654572726F722822617474656D7074656420746F206765742070726976617465206669656C64206F6E206E6F6E2D696E7374616E636522293B72657475726E20632E6765743F632E';
wwv_flow_api.g_varchar2_table(136) := '6765742E63616C6C2861293A632E76616C75657D66756E6374696F6E206E28612C622C632C642C652C66297B76617220672C682C693D302C6A3D302C6B3D302C6C3D302C6D3D302C6E3D302C6F3D66756E6374696F6E2861297B72657475726E2828692A';
wwv_flow_api.g_varchar2_table(137) := '612B6A292A612B6B292A617D2C703D66756E6374696F6E2861297B72657475726E28332A692A612B322A6A292A612B6B7D2C713D66756E6374696F6E2861297B72657475726E20613E3D303F613A302D617D3B72657475726E20693D312D286B3D332A62';
wwv_flow_api.g_varchar2_table(138) := '292D286A3D332A28642D62292D6B292C6C3D312D286E3D332A63292D286D3D332A28652D63292D6E292C673D612C683D66756E6374696F6E2861297B72657475726E20312F283230302A61297D2866292C66756E6374696F6E2861297B72657475726E28';
wwv_flow_api.g_varchar2_table(139) := '286C2A612B6D292A612B6E292A617D2866756E6374696F6E28612C62297B76617220632C642C652C662C672C683B666F7228653D612C683D303B683C383B682B2B297B696628663D6F2865292D612C712866293C622972657475726E20653B696628673D';
wwv_flow_api.g_varchar2_table(140) := '702865292C712867293C31652D3629627265616B3B652D3D662F677D69662828653D61293C28633D30292972657475726E20633B696628653E28643D31292972657475726E20643B666F72283B633C643B297B696628663D6F2865292C7128662D61293C';
wwv_flow_api.g_varchar2_table(141) := '622972657475726E20653B613E663F633D653A643D652C653D2E352A28642D63292B637D72657475726E20657D28672C6829297D632E722862293B766172206F3D7B7D3B632E72286F292C632E64286F2C22646F65734170706C79222C66756E6374696F';
wwv_flow_api.g_varchar2_table(142) := '6E28297B72657475726E204D7D292C632E64286F2C22747765656E43726561746564222C66756E6374696F6E28297B72657475726E20657D292C632E64286F2C226265666F7265547765656E222C66756E6374696F6E28297B72657475726E20667D292C';
wwv_flow_api.g_varchar2_table(143) := '632E64286F2C226166746572547765656E222C66756E6374696F6E28297B72657475726E20677D293B76617220702C712C723D632830292C733D2F285C647C2D7C5C2E292F2C743D2F285B5E5C2D302D392E5D2B292F672C753D2F5B302D392E2D5D2B2F';
wwv_flow_api.g_varchar2_table(144) := '672C763D28703D752E736F757263652C713D2F2C5C732A2F2E736F757263652C6E65772052656745787028227267625C5C28222E636F6E6361742870292E636F6E6361742871292E636F6E6361742870292E636F6E6361742871292E636F6E6361742870';
wwv_flow_api.g_varchar2_table(145) := '2C225C5C2922292C22672229292C773D2F5E2E2A5C282F2C783D2F23285B302D395D7C5B612D665D297B332C367D2F67692C793D66756E6374696F6E28612C62297B72657475726E20612E6D61702866756E6374696F6E28612C63297B72657475726E22';
wwv_flow_api.g_varchar2_table(146) := '5F222E636F6E63617428622C225F22292E636F6E6361742863297D297D2C7A3D66756E6374696F6E2861297B72657475726E2272676228222E636F6E6361742828623D612C333D3D3D28623D622E7265706C616365282F232F2C222229292E6C656E6774';
wwv_flow_api.g_varchar2_table(147) := '68262628623D28623D622E73706C697428222229295B305D2B625B305D2B625B315D2B625B315D2B625B325D2B625B325D292C5B6428622E73756273747228302C3229292C6428622E73756273747228322C3229292C6428622E73756273747228342C32';
wwv_flow_api.g_varchar2_table(148) := '29295D292E6A6F696E28222C22292C222922293B76617220627D2C413D66756E6374696F6E28612C622C63297B76617220643D622E6D617463682861292C653D622E7265706C61636528612C2256414C22293B72657475726E20642626642E666F724561';
wwv_flow_api.g_varchar2_table(149) := '63682866756E6374696F6E2861297B72657475726E20653D652E7265706C616365282256414C222C63286129297D292C657D2C423D66756E6374696F6E2861297B666F7228766172206220696E2061297B76617220633D615B625D3B22737472696E6722';
wwv_flow_api.g_varchar2_table(150) := '3D3D747970656F6620632626632E6D61746368287829262628615B625D3D4128782C632C7A29297D7D2C433D66756E6374696F6E2861297B76617220623D612E6D617463682875292E6D6170284D6174682E666C6F6F72293B72657475726E22222E636F';
wwv_flow_api.g_varchar2_table(151) := '6E63617428612E6D617463682877295B305D292E636F6E63617428622E6A6F696E28222C22292C222922297D2C443D66756E6374696F6E2861297B72657475726E20612E6D617463682875297D2C453D66756E6374696F6E2861297B76617220622C632C';
wwv_flow_api.g_varchar2_table(152) := '643D7B7D3B666F7228766172206520696E2061297B76617220663D615B655D3B22737472696E67223D3D747970656F662066262628645B655D3D7B666F726D6174537472696E673A28623D662C633D766F696420302C633D622E6D617463682874292C63';
wwv_flow_api.g_varchar2_table(153) := '3F28313D3D3D632E6C656E6774687C7C622E6368617241742830292E6D61746368287329292626632E756E7368696674282222293A633D5B22222C22225D2C632E6A6F696E282256414C2229292C6368756E6B4E616D65733A7928442866292C65297D29';
wwv_flow_api.g_varchar2_table(154) := '7D72657475726E20647D2C463D66756E6374696F6E28612C62297B76617220633D66756E6374696F6E2863297B4428615B635D292E666F72456163682866756E6374696F6E28642C65297B72657475726E20615B625B635D2E6368756E6B4E616D65735B';
wwv_flow_api.g_varchar2_table(155) := '655D5D3D2B647D292C64656C65746520615B635D7D3B666F7228766172206420696E206229632864297D2C473D66756E6374696F6E28612C62297B76617220633D7B7D3B72657475726E20622E666F72456163682866756E6374696F6E2862297B635B62';
wwv_flow_api.g_varchar2_table(156) := '5D3D615B625D2C64656C65746520615B625D7D292C637D2C483D66756E6374696F6E28612C62297B72657475726E20622E6D61702866756E6374696F6E2862297B72657475726E20615B625D7D297D2C493D66756E6374696F6E28612C62297B72657475';
wwv_flow_api.g_varchar2_table(157) := '726E20622E666F72456163682866756E6374696F6E2862297B72657475726E20613D612E7265706C616365282256414C222C2B622E746F4669786564283429297D292C617D2C4A3D66756E6374696F6E28612C62297B666F7228766172206320696E2062';
wwv_flow_api.g_varchar2_table(158) := '297B76617220643D625B635D2C653D642E6368756E6B4E616D65732C663D642E666F726D6174537472696E672C673D4928662C48284728612C65292C6529293B615B635D3D4128762C672C43297D7D2C4B3D66756E6374696F6E28612C62297B76617220';
wwv_flow_api.g_varchar2_table(159) := '633D66756E6374696F6E2863297B76617220643D625B635D2E6368756E6B4E616D65732C653D615B635D3B69662822737472696E67223D3D747970656F662065297B76617220663D652E73706C697428222022292C673D665B662E6C656E6774682D315D';
wwv_flow_api.g_varchar2_table(160) := '3B642E666F72456163682866756E6374696F6E28622C63297B72657475726E20615B625D3D665B635D7C7C677D297D656C736520642E666F72456163682866756E6374696F6E2862297B72657475726E20615B625D3D657D293B64656C65746520615B63';
wwv_flow_api.g_varchar2_table(161) := '5D7D3B666F7228766172206420696E206229632864297D2C4C3D66756E6374696F6E28612C62297B666F7228766172206320696E2062297B76617220643D625B635D2E6368756E6B4E616D65732C653D615B645B305D5D3B615B635D3D22737472696E67';
wwv_flow_api.g_varchar2_table(162) := '223D3D747970656F6620653F642E6D61702866756E6374696F6E2862297B76617220633D615B625D3B72657475726E2064656C65746520615B625D2C637D292E6A6F696E28222022293A657D7D2C4D3D66756E6374696F6E2861297B76617220623D612E';
wwv_flow_api.g_varchar2_table(163) := '5F63757272656E7453746174653B72657475726E204F626A6563742E6B6579732862292E736F6D652866756E6374696F6E2861297B72657475726E22737472696E67223D3D747970656F6620625B615D7D297D2C4E3D6E657720722E612C4F3D722E612E';
wwv_flow_api.g_varchar2_table(164) := '66696C746572732C503D66756E6374696F6E28612C622C632C64297B76617220653D617267756D656E74732E6C656E6774683E342626766F69642030213D3D617267756D656E74735B345D3F617267756D656E74735B345D3A302C663D69287B7D2C6129';
wwv_flow_api.g_varchar2_table(165) := '2C673D4F626A65637428722E622928612C64293B666F7228766172206820696E204E2E5F66696C746572732E6C656E6774683D302C4E2E736574287B7D292C4E2E5F63757272656E7453746174653D662C4E2E5F6F726967696E616C53746174653D612C';
wwv_flow_api.g_varchar2_table(166) := '4E2E5F74617267657453746174653D622C4E2E5F656173696E673D672C4F294F5B685D2E646F65734170706C79284E2926264E2E5F66696C746572732E70757368284F5B685D293B4E2E5F6170706C7946696C7465722822747765656E43726561746564';
wwv_flow_api.g_varchar2_table(167) := '22292C4E2E5F6170706C7946696C74657228226265666F7265547765656E22293B766172206A3D4F626A65637428722E652928632C662C612C622C312C652C67293B72657475726E204E2E5F6170706C7946696C74657228226166746572547765656E22';
wwv_flow_api.g_varchar2_table(168) := '292C6A7D2C513D66756E6374696F6E28297B66756E6374696F6E206128297B2166756E6374696F6E28612C62297B69662821286120696E7374616E63656F66206229297468726F77206E657720547970654572726F72282243616E6E6F742063616C6C20';
wwv_flow_api.g_varchar2_table(169) := '6120636C61737320617320612066756E6374696F6E22297D28746869732C61292C522E73657428746869732C7B7772697461626C653A21302C76616C75653A5B5D7D293B666F722876617220623D617267756D656E74732E6C656E6774682C633D6E6577';
wwv_flow_api.g_varchar2_table(170) := '2041727261792862292C643D303B643C623B642B2B29635B645D3D617267756D656E74735B645D3B632E666F724561636828746869732E6164642E62696E64287468697329297D76617220622C632C643B72657475726E20623D612C28633D5B7B6B6579';
wwv_flow_api.g_varchar2_table(171) := '3A22616464222C76616C75653A66756E6374696F6E2861297B72657475726E206D28746869732C52292E707573682861292C617D7D2C7B6B65793A2272656D6F7665222C76616C75653A66756E6374696F6E2861297B76617220623D6D28746869732C52';
wwv_flow_api.g_varchar2_table(172) := '292E696E6465784F662861293B72657475726E7E6226266D28746869732C52292E73706C69636528622C31292C617D7D2C7B6B65793A22656D707479222C76616C75653A66756E6374696F6E28297B72657475726E20746869732E747765656E61626C65';
wwv_flow_api.g_varchar2_table(173) := '732E6D617028746869732E72656D6F76652E62696E64287468697329297D7D2C7B6B65793A226973506C6179696E67222C76616C75653A66756E6374696F6E28297B72657475726E206D28746869732C52292E736F6D652866756E6374696F6E2861297B';
wwv_flow_api.g_varchar2_table(174) := '72657475726E20612E6973506C6179696E6728297D297D7D2C7B6B65793A22706C6179222C76616C75653A66756E6374696F6E28297B72657475726E206D28746869732C52292E666F72456163682866756E6374696F6E2861297B72657475726E20612E';
wwv_flow_api.g_varchar2_table(175) := '747765656E28297D292C746869737D7D2C7B6B65793A227061757365222C76616C75653A66756E6374696F6E28297B72657475726E206D28746869732C52292E666F72456163682866756E6374696F6E2861297B72657475726E20612E70617573652829';
wwv_flow_api.g_varchar2_table(176) := '7D292C746869737D7D2C7B6B65793A22726573756D65222C76616C75653A66756E6374696F6E28297B72657475726E206D28746869732C52292E666F72456163682866756E6374696F6E2861297B72657475726E20612E726573756D6528297D292C7468';
wwv_flow_api.g_varchar2_table(177) := '69737D7D2C7B6B65793A2273746F70222C76616C75653A66756E6374696F6E2861297B72657475726E206D28746869732C52292E666F72456163682866756E6374696F6E2862297B72657475726E20622E73746F702861297D292C746869737D7D2C7B6B';
wwv_flow_api.g_varchar2_table(178) := '65793A22747765656E61626C6573222C6765743A66756E6374696F6E28297B72657475726E206B286D28746869732C5229297D7D2C7B6B65793A2270726F6D69736573222C6765743A66756E6374696F6E28297B72657475726E206D28746869732C5229';
wwv_flow_api.g_varchar2_table(179) := '2E6D61702866756E6374696F6E2861297B72657475726E20612E5F70726F6D6973657D297D7D5D2926266C28622E70726F746F747970652C63292C6426266C28622C64292C617D28292C523D6E6577205765616B4D61702C533D66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(180) := '2C622C632C642C65297B76617220663D66756E6374696F6E28612C622C632C64297B72657475726E2066756E6374696F6E2865297B72657475726E206E28652C612C622C632C642C31297D7D28622C632C642C65293B72657475726E20662E646973706C';
wwv_flow_api.g_varchar2_table(181) := '61794E616D653D612C662E78313D622C662E79313D632C662E78323D642C662E79323D652C722E612E666F726D756C61735B615D3D667D2C543D66756E6374696F6E2861297B72657475726E2064656C65746520722E612E666F726D756C61735B615D7D';
wwv_flow_api.g_varchar2_table(182) := '3B632E6428622C2270726F63657373547765656E73222C66756E6374696F6E28297B72657475726E20722E637D292C632E6428622C22547765656E61626C65222C66756E6374696F6E28297B72657475726E20722E617D292C632E6428622C2274776565';
wwv_flow_api.g_varchar2_table(183) := '6E222C66756E6374696F6E28297B72657475726E20722E647D292C632E6428622C22696E746572706F6C617465222C66756E6374696F6E28297B72657475726E20507D292C632E6428622C225363656E65222C66756E6374696F6E28297B72657475726E';
wwv_flow_api.g_varchar2_table(184) := '20517D292C632E6428622C2273657442657A69657246756E6374696F6E222C66756E6374696F6E28297B72657475726E20537D292C632E6428622C22756E73657442657A69657246756E6374696F6E222C66756E6374696F6E28297B72657475726E2054';
wwv_flow_api.g_varchar2_table(185) := '7D292C722E612E66696C746572732E746F6B656E3D6F7D5D297D297D2C7B7D5D2C323A5B66756E6374696F6E28612C622C63297B76617220643D6128222E2F736861706522292C653D6128222E2F7574696C7322292C663D66756E6374696F6E28612C62';
wwv_flow_api.g_varchar2_table(186) := '297B746869732E5F7061746854656D706C6174653D224D2035302C3530206D20302C2D7B7261646975737D2061207B7261646975737D2C7B7261646975737D20302031203120302C7B327261646975737D2061207B7261646975737D2C7B726164697573';
wwv_flow_api.g_varchar2_table(187) := '7D20302031203120302C2D7B327261646975737D222C746869732E636F6E7461696E6572417370656374526174696F3D312C642E6170706C7928746869732C617267756D656E7473297D3B662E70726F746F747970653D6E657720642C662E70726F746F';
wwv_flow_api.g_varchar2_table(188) := '747970652E636F6E7374727563746F723D662C662E70726F746F747970652E5F70617468537472696E673D66756E6374696F6E2861297B76617220623D612E7374726F6B6557696474683B612E747261696C57696474682626612E747261696C57696474';
wwv_flow_api.g_varchar2_table(189) := '683E612E7374726F6B655769647468262628623D612E747261696C5769647468293B76617220633D35302D622F323B72657475726E20652E72656E64657228746869732E5F7061746854656D706C6174652C7B7261646975733A632C2232726164697573';
wwv_flow_api.g_varchar2_table(190) := '223A322A637D297D2C662E70726F746F747970652E5F747261696C537472696E673D66756E6374696F6E2861297B72657475726E20746869732E5F70617468537472696E672861297D2C622E6578706F7274733D667D2C7B222E2F7368617065223A372C';
wwv_flow_api.g_varchar2_table(191) := '222E2F7574696C73223A397D5D2C333A5B66756E6374696F6E28612C622C63297B76617220643D6128222E2F736861706522292C653D6128222E2F7574696C7322292C663D66756E6374696F6E28612C62297B746869732E5F7061746854656D706C6174';
wwv_flow_api.g_varchar2_table(192) := '653D622E766572746963616C3F224D207B63656E7465727D2C313030204C207B63656E7465727D2C30223A224D20302C7B63656E7465727D204C203130302C7B63656E7465727D222C642E6170706C7928746869732C617267756D656E7473297D3B662E';
wwv_flow_api.g_varchar2_table(193) := '70726F746F747970653D6E657720642C662E70726F746F747970652E636F6E7374727563746F723D662C662E70726F746F747970652E5F696E697469616C697A655376673D66756E6374696F6E28612C62297B76617220633D622E766572746963616C3F';
wwv_flow_api.g_varchar2_table(194) := '2230203020222B622E7374726F6B6557696474682B2220313030223A223020302031303020222B622E7374726F6B6557696474683B612E736574417474726962757465282276696577426F78222C63292C612E7365744174747269627574652822707265';
wwv_flow_api.g_varchar2_table(195) := '7365727665417370656374526174696F222C226E6F6E6522297D2C662E70726F746F747970652E5F70617468537472696E673D66756E6374696F6E2861297B72657475726E20652E72656E64657228746869732E5F7061746854656D706C6174652C7B63';
wwv_flow_api.g_varchar2_table(196) := '656E7465723A612E7374726F6B6557696474682F327D297D2C662E70726F746F747970652E5F747261696C537472696E673D66756E6374696F6E2861297B72657475726E20746869732E5F70617468537472696E672861297D2C622E6578706F7274733D';
wwv_flow_api.g_varchar2_table(197) := '667D2C7B222E2F7368617065223A372C222E2F7574696C73223A397D5D2C343A5B66756E6374696F6E28612C622C63297B622E6578706F7274733D7B4C696E653A6128222E2F6C696E6522292C436972636C653A6128222E2F636972636C6522292C5365';
wwv_flow_api.g_varchar2_table(198) := '6D69436972636C653A6128222E2F73656D69636972636C6522292C5371756172653A6128222E2F73717561726522292C506174683A6128222E2F7061746822292C53686170653A6128222E2F736861706522292C7574696C733A6128222E2F7574696C73';
wwv_flow_api.g_varchar2_table(199) := '22297D7D2C7B222E2F636972636C65223A322C222E2F6C696E65223A332C222E2F70617468223A352C222E2F73656D69636972636C65223A362C222E2F7368617065223A372C222E2F737175617265223A382C222E2F7574696C73223A397D5D2C353A5B';
wwv_flow_api.g_varchar2_table(200) := '66756E6374696F6E28612C622C63297B76617220643D61282273686966747922292C653D6128222E2F7574696C7322292C663D642E547765656E61626C652C673D7B65617365496E3A2265617365496E4375626963222C656173654F75743A2265617365';
wwv_flow_api.g_varchar2_table(201) := '4F75744375626963222C65617365496E4F75743A2265617365496E4F75744375626963227D2C683D66756E6374696F6E206128622C63297B69662821287468697320696E7374616E63656F66206129297468726F77206E6577204572726F722822436F6E';
wwv_flow_api.g_varchar2_table(202) := '7374727563746F72207761732063616C6C656420776974686F7574206E6577206B6579776F726422293B633D652E657874656E64287B64656C61793A302C6475726174696F6E3A3830302C656173696E673A226C696E656172222C66726F6D3A7B7D2C74';
wwv_flow_api.g_varchar2_table(203) := '6F3A7B7D2C737465703A66756E6374696F6E28297B7D7D2C63293B76617220643B643D652E6973537472696E672862293F646F63756D656E742E717565727953656C6563746F722862293A622C746869732E706174683D642C746869732E5F6F7074733D';
wwv_flow_api.g_varchar2_table(204) := '632C746869732E5F747765656E61626C653D6E756C6C3B76617220663D746869732E706174682E676574546F74616C4C656E67746828293B746869732E706174682E7374796C652E7374726F6B654461736861727261793D662B2220222B662C74686973';
wwv_flow_api.g_varchar2_table(205) := '2E7365742830297D3B682E70726F746F747970652E76616C75653D66756E6374696F6E28297B76617220613D746869732E5F676574436F6D7075746564446173684F666673657428292C623D746869732E706174682E676574546F74616C4C656E677468';
wwv_flow_api.g_varchar2_table(206) := '28292C633D312D612F623B72657475726E207061727365466C6F617428632E746F46697865642836292C3130297D2C682E70726F746F747970652E7365743D66756E6374696F6E2861297B746869732E73746F7028292C746869732E706174682E737479';
wwv_flow_api.g_varchar2_table(207) := '6C652E7374726F6B65446173686F66667365743D746869732E5F70726F6772657373546F4F66667365742861293B76617220623D746869732E5F6F7074732E737465703B696628652E697346756E6374696F6E286229297B76617220633D746869732E5F';
wwv_flow_api.g_varchar2_table(208) := '656173696E6728746869732E5F6F7074732E656173696E67293B6228746869732E5F63616C63756C617465546F28612C63292C746869732E5F6F7074732E73686170657C7C746869732C746869732E5F6F7074732E6174746163686D656E74297D7D2C68';
wwv_flow_api.g_varchar2_table(209) := '2E70726F746F747970652E73746F703D66756E6374696F6E28297B746869732E5F73746F70547765656E28292C746869732E706174682E7374796C652E7374726F6B65446173686F66667365743D746869732E5F676574436F6D7075746564446173684F';
wwv_flow_api.g_varchar2_table(210) := '666673657428297D2C682E70726F746F747970652E616E696D6174653D66756E6374696F6E28612C622C63297B623D627C7C7B7D2C652E697346756E6374696F6E286229262628633D622C623D7B7D293B76617220643D652E657874656E64287B7D2C62';
wwv_flow_api.g_varchar2_table(211) := '292C673D652E657874656E64287B7D2C746869732E5F6F707473293B623D652E657874656E6428672C62293B76617220683D746869732E5F656173696E6728622E656173696E67292C693D746869732E5F7265736F6C766546726F6D416E64546F28612C';
wwv_flow_api.g_varchar2_table(212) := '682C64293B746869732E73746F7028292C746869732E706174682E676574426F756E64696E67436C69656E745265637428293B766172206A3D746869732E5F676574436F6D7075746564446173684F666673657428292C6B3D746869732E5F70726F6772';
wwv_flow_api.g_varchar2_table(213) := '657373546F4F66667365742861292C6C3D746869733B746869732E5F747765656E61626C653D6E657720662C746869732E5F747765656E61626C652E747765656E287B66726F6D3A652E657874656E64287B6F66667365743A6A7D2C692E66726F6D292C';
wwv_flow_api.g_varchar2_table(214) := '746F3A652E657874656E64287B6F66667365743A6B7D2C692E746F292C6475726174696F6E3A622E6475726174696F6E2C64656C61793A622E64656C61792C656173696E673A682C737465703A66756E6374696F6E2861297B6C2E706174682E7374796C';
wwv_flow_api.g_varchar2_table(215) := '652E7374726F6B65446173686F66667365743D612E6F66667365743B76617220633D622E73686170657C7C6C3B622E7374657028612C632C622E6174746163686D656E74297D7D292E7468656E2866756E6374696F6E2861297B652E697346756E637469';
wwv_flow_api.g_varchar2_table(216) := '6F6E28632926266328297D292E63617463682866756E6374696F6E2861297B7468726F7720636F6E736F6C652E6572726F7228224572726F7220696E20747765656E696E673A222C61292C617D297D2C682E70726F746F747970652E5F676574436F6D70';
wwv_flow_api.g_varchar2_table(217) := '75746564446173684F66667365743D66756E6374696F6E28297B76617220613D77696E646F772E676574436F6D70757465645374796C6528746869732E706174682C6E756C6C293B72657475726E207061727365466C6F617428612E67657450726F7065';
wwv_flow_api.g_varchar2_table(218) := '72747956616C756528227374726F6B652D646173686F666673657422292C3130297D2C682E70726F746F747970652E5F70726F6772657373546F4F66667365743D66756E6374696F6E2861297B76617220623D746869732E706174682E676574546F7461';
wwv_flow_api.g_varchar2_table(219) := '6C4C656E67746828293B72657475726E20622D612A627D2C682E70726F746F747970652E5F7265736F6C766546726F6D416E64546F3D66756E6374696F6E28612C622C63297B72657475726E20632E66726F6D2626632E746F3F7B66726F6D3A632E6672';
wwv_flow_api.g_varchar2_table(220) := '6F6D2C746F3A632E746F7D3A7B66726F6D3A746869732E5F63616C63756C61746546726F6D2862292C746F3A746869732E5F63616C63756C617465546F28612C62297D7D2C682E70726F746F747970652E5F63616C63756C61746546726F6D3D66756E63';
wwv_flow_api.g_varchar2_table(221) := '74696F6E2861297B72657475726E20642E696E746572706F6C61746528746869732E5F6F7074732E66726F6D2C746869732E5F6F7074732E746F2C746869732E76616C756528292C61297D2C682E70726F746F747970652E5F63616C63756C617465546F';

wwv_flow_api.g_varchar2_table(222) := '3D66756E6374696F6E28612C62297B72657475726E20642E696E746572706F6C61746528746869732E5F6F7074732E66726F6D2C746869732E5F6F7074732E746F2C612C62297D2C682E70726F746F747970652E5F73746F70547765656E3D66756E6374';
wwv_flow_api.g_varchar2_table(223) := '696F6E28297B6E756C6C213D3D746869732E5F747765656E61626C65262628746869732E5F747765656E61626C652E73746F70282130292C746869732E5F747765656E61626C653D6E756C6C297D2C682E70726F746F747970652E5F656173696E673D66';
wwv_flow_api.g_varchar2_table(224) := '756E6374696F6E2861297B72657475726E20672E6861734F776E50726F70657274792861293F675B615D3A617D2C622E6578706F7274733D687D2C7B222E2F7574696C73223A392C7368696674793A317D5D2C363A5B66756E6374696F6E28612C622C63';
wwv_flow_api.g_varchar2_table(225) := '297B76617220643D6128222E2F736861706522292C653D6128222E2F636972636C6522292C663D6128222E2F7574696C7322292C673D66756E6374696F6E28612C62297B746869732E5F7061746854656D706C6174653D224D2035302C3530206D202D7B';
wwv_flow_api.g_varchar2_table(226) := '7261646975737D2C302061207B7261646975737D2C7B7261646975737D203020312031207B327261646975737D2C30222C746869732E636F6E7461696E6572417370656374526174696F3D322C642E6170706C7928746869732C617267756D656E747329';
wwv_flow_api.g_varchar2_table(227) := '7D3B672E70726F746F747970653D6E657720642C672E70726F746F747970652E636F6E7374727563746F723D672C672E70726F746F747970652E5F696E697469616C697A655376673D66756E6374696F6E28612C62297B612E7365744174747269627574';
wwv_flow_api.g_varchar2_table(228) := '65282276696577426F78222C223020302031303020353022297D2C672E70726F746F747970652E5F696E697469616C697A6554657874436F6E7461696E65723D66756E6374696F6E28612C622C63297B612E746578742E7374796C65262628632E737479';
wwv_flow_api.g_varchar2_table(229) := '6C652E746F703D226175746F222C632E7374796C652E626F74746F6D3D2230222C612E746578742E616C69676E546F426F74746F6D3F662E7365745374796C6528632C227472616E73666F726D222C227472616E736C617465282D3530252C2030292229';
wwv_flow_api.g_varchar2_table(230) := '3A662E7365745374796C6528632C227472616E73666F726D222C227472616E736C617465282D3530252C20353025292229297D2C672E70726F746F747970652E5F70617468537472696E673D652E70726F746F747970652E5F70617468537472696E672C';
wwv_flow_api.g_varchar2_table(231) := '672E70726F746F747970652E5F747261696C537472696E673D652E70726F746F747970652E5F747261696C537472696E672C622E6578706F7274733D677D2C7B222E2F636972636C65223A322C222E2F7368617065223A372C222E2F7574696C73223A39';
wwv_flow_api.g_varchar2_table(232) := '7D5D2C373A5B66756E6374696F6E28612C622C63297B76617220643D6128222E2F7061746822292C653D6128222E2F7574696C7322292C663D224F626A6563742069732064657374726F796564222C673D66756E6374696F6E206128622C63297B696628';
wwv_flow_api.g_varchar2_table(233) := '21287468697320696E7374616E63656F66206129297468726F77206E6577204572726F722822436F6E7374727563746F72207761732063616C6C656420776974686F7574206E6577206B6579776F726422293B69662830213D3D617267756D656E74732E';
wwv_flow_api.g_varchar2_table(234) := '6C656E677468297B746869732E5F6F7074733D652E657874656E64287B636F6C6F723A2223353535222C7374726F6B6557696474683A312C747261696C436F6C6F723A6E756C6C2C747261696C57696474683A6E756C6C2C66696C6C3A6E756C6C2C7465';
wwv_flow_api.g_varchar2_table(235) := '78743A7B7374796C653A7B636F6C6F723A6E756C6C2C706F736974696F6E3A226162736F6C757465222C6C6566743A22353025222C746F703A22353025222C70616464696E673A302C6D617267696E3A302C7472616E73666F726D3A7B7072656669783A';
wwv_flow_api.g_varchar2_table(236) := '21302C76616C75653A227472616E736C617465282D3530252C202D35302529227D7D2C6175746F5374796C65436F6E7461696E65723A21302C616C69676E546F426F74746F6D3A21302C76616C75653A6E756C6C2C636C6173734E616D653A2270726F67';
wwv_flow_api.g_varchar2_table(237) := '726573736261722D74657874227D2C7376675374796C653A7B646973706C61793A22626C6F636B222C77696474683A2231303025227D2C7761726E696E67733A21317D2C632C2130292C652E69734F626A6563742863292626766F69642030213D3D632E';
wwv_flow_api.g_varchar2_table(238) := '7376675374796C65262628746869732E5F6F7074732E7376675374796C653D632E7376675374796C65292C652E69734F626A6563742863292626652E69734F626A65637428632E74657874292626766F69642030213D3D632E746578742E7374796C6526';
wwv_flow_api.g_varchar2_table(239) := '2628746869732E5F6F7074732E746578742E7374796C653D632E746578742E7374796C65293B76617220662C673D746869732E5F6372656174655376675669657728746869732E5F6F707473293B6966282128663D652E6973537472696E672862293F64';
wwv_flow_api.g_varchar2_table(240) := '6F63756D656E742E717565727953656C6563746F722862293A6229297468726F77206E6577204572726F722822436F6E7461696E657220646F6573206E6F742065786973743A20222B62293B746869732E5F636F6E7461696E65723D662C746869732E5F';
wwv_flow_api.g_varchar2_table(241) := '636F6E7461696E65722E617070656E644368696C6428672E737667292C746869732E5F6F7074732E7761726E696E67732626746869732E5F7761726E436F6E7461696E6572417370656374526174696F28746869732E5F636F6E7461696E6572292C7468';
wwv_flow_api.g_varchar2_table(242) := '69732E5F6F7074732E7376675374796C652626652E7365745374796C657328672E7376672C746869732E5F6F7074732E7376675374796C65292C746869732E7376673D672E7376672C746869732E706174683D672E706174682C746869732E747261696C';
wwv_flow_api.g_varchar2_table(243) := '3D672E747261696C2C746869732E746578743D6E756C6C3B76617220683D652E657874656E64287B6174746163686D656E743A766F696420302C73686170653A746869737D2C746869732E5F6F707473293B746869732E5F70726F677265737350617468';
wwv_flow_api.g_varchar2_table(244) := '3D6E6577206428672E706174682C68292C652E69734F626A65637428746869732E5F6F7074732E746578742926266E756C6C213D3D746869732E5F6F7074732E746578742E76616C75652626746869732E7365745465787428746869732E5F6F7074732E';
wwv_flow_api.g_varchar2_table(245) := '746578742E76616C7565297D7D3B672E70726F746F747970652E616E696D6174653D66756E6374696F6E28612C622C63297B6966286E756C6C3D3D3D746869732E5F70726F677265737350617468297468726F77206E6577204572726F722866293B7468';
wwv_flow_api.g_varchar2_table(246) := '69732E5F70726F6772657373506174682E616E696D61746528612C622C63297D2C672E70726F746F747970652E73746F703D66756E6374696F6E28297B6966286E756C6C3D3D3D746869732E5F70726F677265737350617468297468726F77206E657720';
wwv_flow_api.g_varchar2_table(247) := '4572726F722866293B766F69642030213D3D746869732E5F70726F6772657373506174682626746869732E5F70726F6772657373506174682E73746F7028297D2C672E70726F746F747970652E70617573653D66756E6374696F6E28297B6966286E756C';
wwv_flow_api.g_varchar2_table(248) := '6C3D3D3D746869732E5F70726F677265737350617468297468726F77206E6577204572726F722866293B766F69642030213D3D746869732E5F70726F6772657373506174682626746869732E5F70726F6772657373506174682E5F747765656E61626C65';
wwv_flow_api.g_varchar2_table(249) := '2626746869732E5F70726F6772657373506174682E5F747765656E61626C652E706175736528297D2C672E70726F746F747970652E726573756D653D66756E6374696F6E28297B6966286E756C6C3D3D3D746869732E5F70726F67726573735061746829';
wwv_flow_api.g_varchar2_table(250) := '7468726F77206E6577204572726F722866293B766F69642030213D3D746869732E5F70726F6772657373506174682626746869732E5F70726F6772657373506174682E5F747765656E61626C652626746869732E5F70726F6772657373506174682E5F74';
wwv_flow_api.g_varchar2_table(251) := '7765656E61626C652E726573756D6528297D2C672E70726F746F747970652E64657374726F793D66756E6374696F6E28297B6966286E756C6C3D3D3D746869732E5F70726F677265737350617468297468726F77206E6577204572726F722866293B7468';
wwv_flow_api.g_varchar2_table(252) := '69732E73746F7028292C746869732E7376672E706172656E744E6F64652E72656D6F76654368696C6428746869732E737667292C746869732E7376673D6E756C6C2C746869732E706174683D6E756C6C2C746869732E747261696C3D6E756C6C2C746869';
wwv_flow_api.g_varchar2_table(253) := '732E5F70726F6772657373506174683D6E756C6C2C6E756C6C213D3D746869732E74657874262628746869732E746578742E706172656E744E6F64652E72656D6F76654368696C6428746869732E74657874292C746869732E746578743D6E756C6C297D';
wwv_flow_api.g_varchar2_table(254) := '2C672E70726F746F747970652E7365743D66756E6374696F6E2861297B6966286E756C6C3D3D3D746869732E5F70726F677265737350617468297468726F77206E6577204572726F722866293B746869732E5F70726F6772657373506174682E73657428';
wwv_flow_api.g_varchar2_table(255) := '61297D2C672E70726F746F747970652E76616C75653D66756E6374696F6E28297B6966286E756C6C3D3D3D746869732E5F70726F677265737350617468297468726F77206E6577204572726F722866293B72657475726E20766F696420303D3D3D746869';
wwv_flow_api.g_varchar2_table(256) := '732E5F70726F6772657373506174683F303A746869732E5F70726F6772657373506174682E76616C756528297D2C672E70726F746F747970652E736574546578743D66756E6374696F6E2861297B6966286E756C6C3D3D3D746869732E5F70726F677265';
wwv_flow_api.g_varchar2_table(257) := '737350617468297468726F77206E6577204572726F722866293B6E756C6C3D3D3D746869732E74657874262628746869732E746578743D746869732E5F63726561746554657874436F6E7461696E657228746869732E5F6F7074732C746869732E5F636F';
wwv_flow_api.g_varchar2_table(258) := '6E7461696E6572292C746869732E5F636F6E7461696E65722E617070656E644368696C6428746869732E7465787429292C652E69734F626A6563742861293F28652E72656D6F76654368696C6472656E28746869732E74657874292C746869732E746578';
wwv_flow_api.g_varchar2_table(259) := '742E617070656E644368696C64286129293A746869732E746578742E696E6E657248544D4C3D617D2C672E70726F746F747970652E5F637265617465537667566965773D66756E6374696F6E2861297B76617220623D646F63756D656E742E6372656174';
wwv_flow_api.g_varchar2_table(260) := '65456C656D656E744E532822687474703A2F2F7777772E77332E6F72672F323030302F737667222C2273766722293B746869732E5F696E697469616C697A6553766728622C61293B76617220633D6E756C6C3B28612E747261696C436F6C6F727C7C612E';
wwv_flow_api.g_varchar2_table(261) := '747261696C576964746829262628633D746869732E5F637265617465547261696C2861292C622E617070656E644368696C64286329293B76617220643D746869732E5F637265617465506174682861293B72657475726E20622E617070656E644368696C';
wwv_flow_api.g_varchar2_table(262) := '642864292C7B7376673A622C706174683A642C747261696C3A637D7D2C672E70726F746F747970652E5F696E697469616C697A655376673D66756E6374696F6E28612C62297B612E736574417474726962757465282276696577426F78222C2230203020';
wwv_flow_api.g_varchar2_table(263) := '3130302031303022297D2C672E70726F746F747970652E5F637265617465506174683D66756E6374696F6E2861297B76617220623D746869732E5F70617468537472696E672861293B72657475726E20746869732E5F63726561746550617468456C656D';
wwv_flow_api.g_varchar2_table(264) := '656E7428622C61297D2C672E70726F746F747970652E5F637265617465547261696C3D66756E6374696F6E2861297B76617220623D746869732E5F747261696C537472696E672861292C633D652E657874656E64287B7D2C61293B72657475726E20632E';
wwv_flow_api.g_varchar2_table(265) := '747261696C436F6C6F727C7C28632E747261696C436F6C6F723D222365656522292C632E747261696C57696474687C7C28632E747261696C57696474683D632E7374726F6B655769647468292C632E636F6C6F723D632E747261696C436F6C6F722C632E';
wwv_flow_api.g_varchar2_table(266) := '7374726F6B6557696474683D632E747261696C57696474682C632E66696C6C3D6E756C6C2C746869732E5F63726561746550617468456C656D656E7428622C63297D2C672E70726F746F747970652E5F63726561746550617468456C656D656E743D6675';
wwv_flow_api.g_varchar2_table(267) := '6E6374696F6E28612C62297B76617220633D646F63756D656E742E637265617465456C656D656E744E532822687474703A2F2F7777772E77332E6F72672F323030302F737667222C227061746822293B72657475726E20632E7365744174747269627574';
wwv_flow_api.g_varchar2_table(268) := '65282264222C61292C632E73657441747472696275746528227374726F6B65222C622E636F6C6F72292C632E73657441747472696275746528227374726F6B652D7769647468222C622E7374726F6B655769647468292C622E66696C6C3F632E73657441';
wwv_flow_api.g_varchar2_table(269) := '7474726962757465282266696C6C222C622E66696C6C293A632E736574417474726962757465282266696C6C2D6F706163697479222C223022292C637D2C672E70726F746F747970652E5F63726561746554657874436F6E7461696E65723D66756E6374';
wwv_flow_api.g_varchar2_table(270) := '696F6E28612C62297B76617220633D646F63756D656E742E637265617465456C656D656E74282264697622293B632E636C6173734E616D653D612E746578742E636C6173734E616D653B76617220643D612E746578742E7374796C653B72657475726E20';
wwv_flow_api.g_varchar2_table(271) := '64262628612E746578742E6175746F5374796C65436F6E7461696E6572262628622E7374796C652E706F736974696F6E3D2272656C617469766522292C652E7365745374796C657328632C64292C642E636F6C6F727C7C28632E7374796C652E636F6C6F';
wwv_flow_api.g_varchar2_table(272) := '723D612E636F6C6F7229292C746869732E5F696E697469616C697A6554657874436F6E7461696E657228612C622C63292C637D2C672E70726F746F747970652E5F696E697469616C697A6554657874436F6E7461696E65723D66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(273) := '622C63297B7D2C672E70726F746F747970652E5F70617468537472696E673D66756E6374696F6E2861297B7468726F77206E6577204572726F7228224F7665727269646520746869732066756E6374696F6E20666F7220656163682070726F6772657373';
wwv_flow_api.g_varchar2_table(274) := '2062617222297D2C672E70726F746F747970652E5F747261696C537472696E673D66756E6374696F6E2861297B7468726F77206E6577204572726F7228224F7665727269646520746869732066756E6374696F6E20666F7220656163682070726F677265';
wwv_flow_api.g_varchar2_table(275) := '73732062617222297D2C672E70726F746F747970652E5F7761726E436F6E7461696E6572417370656374526174696F3D66756E6374696F6E2861297B696628746869732E636F6E7461696E6572417370656374526174696F297B76617220623D77696E64';
wwv_flow_api.g_varchar2_table(276) := '6F772E676574436F6D70757465645374796C6528612C6E756C6C292C633D7061727365466C6F617428622E67657450726F706572747956616C75652822776964746822292C3130292C643D7061727365466C6F617428622E67657450726F706572747956';
wwv_flow_api.g_varchar2_table(277) := '616C7565282268656967687422292C3130293B652E666C6F6174457175616C7328746869732E636F6E7461696E6572417370656374526174696F2C632F64297C7C28636F6E736F6C652E7761726E2822496E636F72726563742061737065637420726174';
wwv_flow_api.g_varchar2_table(278) := '696F206F6620636F6E7461696E6572222C2223222B612E69642C2264657465637465643A222C622E67657450726F706572747956616C75652822776964746822292B2228776964746829222C222F222C622E67657450726F706572747956616C75652822';
wwv_flow_api.g_varchar2_table(279) := '68656967687422292B222868656967687429222C223D222C632F64292C636F6E736F6C652E7761726E282241737065637420726174696F206F662073686F756C64206265222C746869732E636F6E7461696E6572417370656374526174696F29297D7D2C';
wwv_flow_api.g_varchar2_table(280) := '622E6578706F7274733D677D2C7B222E2F70617468223A352C222E2F7574696C73223A397D5D2C383A5B66756E6374696F6E28612C622C63297B76617220643D6128222E2F736861706522292C653D6128222E2F7574696C7322292C663D66756E637469';
wwv_flow_api.g_varchar2_table(281) := '6F6E28612C62297B746869732E5F7061746854656D706C6174653D224D20302C7B68616C664F665374726F6B6557696474687D204C207B77696474687D2C7B68616C664F665374726F6B6557696474687D204C207B77696474687D2C7B77696474687D20';
wwv_flow_api.g_varchar2_table(282) := '4C207B68616C664F665374726F6B6557696474687D2C7B77696474687D204C207B68616C664F665374726F6B6557696474687D2C7B7374726F6B6557696474687D222C746869732E5F747261696C54656D706C6174653D224D207B73746172744D617267';
wwv_flow_api.g_varchar2_table(283) := '696E7D2C7B68616C664F665374726F6B6557696474687D204C207B77696474687D2C7B68616C664F665374726F6B6557696474687D204C207B77696474687D2C7B77696474687D204C207B68616C664F665374726F6B6557696474687D2C7B7769647468';
wwv_flow_api.g_varchar2_table(284) := '7D204C207B68616C664F665374726F6B6557696474687D2C7B68616C664F665374726F6B6557696474687D222C642E6170706C7928746869732C617267756D656E7473297D3B662E70726F746F747970653D6E657720642C662E70726F746F747970652E';
wwv_flow_api.g_varchar2_table(285) := '636F6E7374727563746F723D662C662E70726F746F747970652E5F70617468537472696E673D66756E6374696F6E2861297B76617220623D3130302D612E7374726F6B6557696474682F323B72657475726E20652E72656E64657228746869732E5F7061';
wwv_flow_api.g_varchar2_table(286) := '746854656D706C6174652C7B77696474683A622C7374726F6B6557696474683A612E7374726F6B6557696474682C68616C664F665374726F6B6557696474683A612E7374726F6B6557696474682F327D297D2C662E70726F746F747970652E5F74726169';
wwv_flow_api.g_varchar2_table(287) := '6C537472696E673D66756E6374696F6E2861297B76617220623D3130302D612E7374726F6B6557696474682F323B72657475726E20652E72656E64657228746869732E5F747261696C54656D706C6174652C7B77696474683A622C7374726F6B65576964';
wwv_flow_api.g_varchar2_table(288) := '74683A612E7374726F6B6557696474682C68616C664F665374726F6B6557696474683A612E7374726F6B6557696474682F322C73746172744D617267696E3A612E7374726F6B6557696474682F322D612E747261696C57696474682F327D297D2C622E65';
wwv_flow_api.g_varchar2_table(289) := '78706F7274733D667D2C7B222E2F7368617065223A372C222E2F7574696C73223A397D5D2C393A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C622C63297B613D617C7C7B7D2C623D627C7C7B7D2C633D637C7C21313B666F';
wwv_flow_api.g_varchar2_table(290) := '7228766172206520696E206229696628622E6861734F776E50726F7065727479286529297B76617220663D615B655D2C673D625B655D3B6326266C28662926266C2867293F615B655D3D6428662C672C63293A615B655D3D677D72657475726E20617D66';
wwv_flow_api.g_varchar2_table(291) := '756E6374696F6E206528612C62297B76617220633D613B666F7228766172206420696E206229696628622E6861734F776E50726F7065727479286429297B76617220653D625B645D2C663D225C5C7B222B642B225C5C7D222C673D6E6577205265674578';
wwv_flow_api.g_varchar2_table(292) := '7028662C226722293B633D632E7265706C61636528672C65297D72657475726E20637D66756E6374696F6E206628612C622C63297B666F722876617220643D612E7374796C652C653D303B653C702E6C656E6774683B2B2B65297B645B705B655D2B6828';
wwv_flow_api.g_varchar2_table(293) := '62295D3D637D645B625D3D637D66756E6374696F6E206728612C62297B6D28622C66756E6374696F6E28622C63297B6E756C6C213D3D622626766F69642030213D3D622626286C286229262621303D3D3D622E7072656669783F6628612C632C622E7661';
wwv_flow_api.g_varchar2_table(294) := '6C7565293A612E7374796C655B635D3D62297D297D66756E6374696F6E20682861297B72657475726E20612E6368617241742830292E746F55707065724361736528292B612E736C6963652831297D66756E6374696F6E20692861297B72657475726E22';
wwv_flow_api.g_varchar2_table(295) := '737472696E67223D3D747970656F6620617C7C6120696E7374616E63656F6620537472696E677D66756E6374696F6E206A2861297B72657475726E2266756E6374696F6E223D3D747970656F6620617D66756E6374696F6E206B2861297B72657475726E';
wwv_flow_api.g_varchar2_table(296) := '225B6F626A6563742041727261795D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C2861297D66756E6374696F6E206C2861297B72657475726E216B286129262628226F626A656374223D3D747970656F66206126';
wwv_flow_api.g_varchar2_table(297) := '26212161297D66756E6374696F6E206D28612C62297B666F7228766172206320696E206129696628612E6861734F776E50726F7065727479286329297B76617220643D615B635D3B6228642C63297D7D66756E6374696F6E206E28612C62297B72657475';
wwv_flow_api.g_varchar2_table(298) := '726E204D6174682E61627328612D62293C717D66756E6374696F6E206F2861297B666F72283B612E66697273744368696C643B29612E72656D6F76654368696C6428612E66697273744368696C64297D76617220703D225765626B6974204D6F7A204F20';
wwv_flow_api.g_varchar2_table(299) := '6D73222E73706C697428222022292C713D2E3030313B622E6578706F7274733D7B657874656E643A642C72656E6465723A652C7365745374796C653A662C7365745374796C65733A672C6361706974616C697A653A682C6973537472696E673A692C6973';
wwv_flow_api.g_varchar2_table(300) := '46756E6374696F6E3A6A2C69734F626A6563743A6C2C666F72456163684F626A6563743A6D2C666C6F6174457175616C733A6E2C72656D6F76654368696C6472656E3A6F7D7D2C7B7D5D7D2C7B7D2C5B345D292834297D293B0A2F2F2320736F75726365';
wwv_flow_api.g_varchar2_table(301) := '4D617070696E6755524C3D70726F67726573736261722E6D696E2E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(217720173368226724)
,p_plugin_id=>wwv_flow_api.id(217651153971039957)
,p_file_name=>'progressbarjs/js/progressbar.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done


