/* global apex,$ */

window.FOS = window.FOS || {};
FOS.item = FOS.item || {};

FOS.item.progressBar = (function () {
    const MAX_VALUE = 100;
    const MIN_VALUE = 0;
    const MSG_CLS = 'fos-prb-msg-box';
    const PRB_CONTAINER_CLS = 'fos-prb-container';

    const EVENT_COMPLETE = 'fos_prb_progress_complete';
    const EVENT_BEFORE_REFRESH = 'fos_prb_before_refresh';
    const EVENT_AFTER_REFRESH = 'fos_prb_after_refresh';
    const EVENT_INTERVAL_OVER = 'fos_prb_interval_over';

    /**
    *
    * @param {object}   	config 	                    	Configuration object containing the plugin settings
    * @param {string}   	config.name                  	The name of the item
    * @param {string}       config.ajaxId                   Necessary identifier for AJAX calls
    * @param {string}       config.pctVal                   The % value of the progress bar
    * @param {string}       config.msgVal                   The message to be displayed with the item
    * @param {string}       config.height                   Height of the item
    * @param {string}       config.shape                    Shape of the progress bar
    * @param {string}       config.style                    Color style of the item.
    * @param {string}       config.color                    The main color of the bar
    * @param {string}       config.endColor                 Only if style set to "gradient"; the target color.
    * @param {string}       config.trailColor               Color of the progress trail.
    * @param {string}       config.animation                Animtion of the transiotions
    * @param {string}       config.duration                 Duration of the animation
    * @param {string}       config.showPct                  The position of the % value.
    * @param {string}       config.showMsg                  The position of the message.
    * @param {string}       config.customShape              SVG of the custom shape.
    * @param {boolean}      config.addTimer                 Enable auto refresh
    * @param {string}       config.refreshInterval          The refresh interval.
    * @param {string}       config.repetitions              The end of the repeptitions.
    * @param {string}       config.numOfReps                Max allowed repetitions.
    * @param {string}       config.itemsToSubmit            Items used in the source query.
    * @param {boolean}      config.autoStartInterval        Start the timer immediately.
    * @param {boolean}      config.queueAnimations          Start the timer animations immediately or add them to the queue.
    * @param {function}  	initJs  						Optional Initialization JavaScript Code function
    */

    let init = function (config, initJS) {
        // default values
        config.strokeWidth = 10;
        config.trailWidth = 10;
        config.msgColor = '#000000';
        config.msg = config.msg || 'Loading...';
        config.autoStartInterval = false;
        config.lastEndInterval = 50;

        if (initJS && initJS instanceof Function) {
            initJS.call(this, config);
        }

        let itemName = config.name;
        let item$ = $('#' + itemName);
        let itemContainer$ = $('#' + itemName + '_CONTAINER');
        let itemWrapper$ = $('#' + itemName + '_WRAPPER');
        let prbSelector = itemName + '_WRAPPER';
        let targetEl = itemContainer$.find('.' + PRB_CONTAINER_CLS);
        let msgBox, pctBox;

        let createTargetBox = function (pos, type) {
            let el$ = $('<span class="fos-prb-' + type + '-box"></span>');
            if (pos == 'above-element') {
                targetEl.prepend(el$);
            } else if (pos == 'below-element') {
                targetEl.append(el$);
            }
            return el$;
        }

        let mergeValues = function (pctValue, msgValue = config.msg) {
            let container = $('<span></span>');
            if (pctBox) {
                pctBox.text(getPct(itemName, pctValue) + '%');
                if (config.showPct == 'on-element') {
                    container.append(pctBox);
                }
            }

            if (msgBox && config.showMsg == 'on-element') {
                container.append(msgBox);
            }

            return container[0];
        };

        // apply the height
        if (config.height && config.height != '') {
            itemWrapper$.css('height', config.height);
        }

        // basic options object
        let prbOpt = {
            strokeWidth: config.strokeWidth,
            easing: getCamelCase(config.animation),
            duration: parseInt(config.duration),
            color: config.color,
            trailColor: config.trailColor,
            trailWidth: config.trailWidth,
            svgStyle: {
                width: '100%',
                height: '100%'
            }
        };

        // set the gradient values
        if (config.style == 'gradient') {
            prbOpt.from = { color: config.color };
            prbOpt.to = { color: config.endColor };
        }

        // function that will be executed with every step
        // update pct and message
        // set the stroke color
        prbOpt.step = (state, bar) => {
            if ((pctBox || msgBox) && typeof bar.setText === 'function') {
                bar.setText(mergeValues(bar.value()));
            }

            if (config.style == 'gradient') {
                bar.path.setAttribute('stroke', state.color);
            }
        }

        // create the pct element
        if (config.showPct != 'no') {
            pctBox = createTargetBox(config.showPct, 'pct');
        }

        // create the msg element
        if (config.showMsg != 'no') {
            msgBox = createTargetBox(config.showMsg, 'msg');
        }

        // for the "on-element" position we use the api provided by the library
        // for the other position we create the elements
        if (config.showPct == 'on-element' || config.showMsg == 'on-element') {
            prbOpt.text = {
                value: mergeValues(config.pctValue, config.msg),
                className: getCls(config.showPct, config.showMsg),
                alignToBottom: false, // only applies on semi-circle
                autoStyleContainer: true,
                style: {
                    color: config.msgColor
                }
            };
        }

        // if it's a custom shape, we get (/set, if it's not set) the ID of the path element
        if (config.shape == 'custom') {
            let paths = itemWrapper$.find('path');
            prbSelector = itemName + '_fosPrbPath';
            if (paths.length == 0) {
                return;
            }
            paths[paths.length == 2 ? 1 : 0].setAttribute('id', prbSelector);
        }

        // initialize the progressbar
        let prb = new ProgressBar[getShape(config.shape)]('#' + prbSelector, prbOpt);
        // we need to manually set our text for custom shapes
        if (config.shape == 'custom') {
            prb.setText = function (text) {
            }
        }
        // compute the value
        let startValue = computeValue(itemName, config.pctVal) / 100;
        // set the value
        prb.set(startValue);

        // set the message
        let msgEl = itemContainer$.find('.' + MSG_CLS);
        if (msgEl.length > 0) {
            msgEl.text(config.msgVal || config.msg);
        }

        // queue the animations
        let queue = [];
        let queuIsRunning = false;

        function runQueue() {
            queuIsRunning = true;
            if (queue.length == 0) {
                queuIsRunning = false;
                return;
            }
            prb.animate(queue[0].animateValue, function () {
                // trigger complete event
                if (queue[0].newValue == MAX_VALUE) {
                    apex.event.trigger('#' + itemName, EVENT_COMPLETE);
                }
                // remove the animation from the queu
                queue.shift();
                // exectue the next animation
                runQueue();
            });
        }

        // create the APEX item interface
        apex.item.create(itemName, {
            getValue: function () {
                return item$.val();
            },
            setValue: function (value) {
                // check the provided value, we might be setting the message too
                if (msgBox && (typeof value === 'string' || value instanceof String)) {
                    let multiValue = value.split(':');
                    if (multiValue.length > 1) {
                        // we want to set the message once our animation duration completes
                        setTimeout(function () {
                            // it's possible they may include a colon in their message value
                            msgEl.text(multiValue.slice(1).join(':'));
                        }, config.duration);
                    }
                }
                let newValue = computeValue(itemName, value);
                item$.val(newValue);
                // the animation value must be in the range 0 - 1.0
                let animateValue = newValue / 100;
                if (config.queueAnimations) {
                    // add animation to the queue
                    queue.push({ animateValue, newValue });
                    // start the execution (if it's not started yet)
                    if (!queuIsRunning) {
                        runQueue();
                    };
                } else {
                    prb.animate(animateValue, function () {
                        // trigger complete event
                        if (newValue == MAX_VALUE) {
                            apex.event.trigger('#' + itemName, EVENT_COMPLETE);
                        }
                    });
                }
            },
            getMessage: function () {
                if (msgBox) {
                    return msgBox.text();
                }
                return '';
            },
            setMessage: function (msg) {
                if (msgBox) {
                    msgEl.text(msg);
                }
            },
            getInstance: function () {
                return prb;
            },
            refresh: function () {
                let self = this;
                let result = apex.server.plugin(config.ajaxId, {
                    pageItems: config.itemsToSubmit
                }, {
                    refreshObject: '#' + itemName,
                    refreshObjectData: config
                });
                apex.event.trigger('#' + itemName, EVENT_BEFORE_REFRESH, config);
                result.done(function (data) {
                    if (data.success) {
                        self.setValue(data.value || 0);
                        if (data.msg) {
                            // we want to set the message once our animation duration completes
                            setTimeout(function () {
                                if (self.callbacks) {
                                    self.callbacks.setMessage(data.msg);
                                } else {
                                    self.setMessage(data.msg);
                                }
                            }, config.duration);
                        }
                    }
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    apex.debug.error('FOS - Progress Bar - Refresh failed: ' + errorThrown);
                }).always(function () {
                    apex.event.trigger('#' + itemName, EVENT_AFTER_REFRESH, config);
                })
            },
            startInterval: function () {
                if (config.addTimer) {
                    intervalStart();
                }
            },
            endInterval: function () {
                if (config.addTimer) {
                    clearInterval(interval);
                    interval = '';
                }
            }
        });

        let interval;
        let intervalStart = function () {
            if (interval) {
                apex.debug.info('FOS - Progress Bar: The interval is already running.')
                return;
            }
            let intervalS = parseInt(config.refreshInterval);
            let numOfReps = parseInt(config.numOfReps || 0);
            let counter = 0;
            interval = setInterval(function () {
                counter++;
                if (config.repetitions == 'progress-is-complete') {
                    if (parseInt(apex.item(itemName).getValue()) >= 100) {
                        endInterval(interval);
                        return;
                    }
                } else if (config.repetitions == 'number-of-repetitions') {
                    if (numOfReps <= counter) {
                        endInterval(interval);
                        return;
                    }
                }

                if (counter > config.lastEndInterval) {
                    endInterval(interval);
                    return;
                }
                apex.item(itemName).refresh();
            }, intervalS);
        }

        if (config.addTimer && config.autoStartInterval) {
            intervalStart();
        };

        let endInterval = function () {
            clearInterval(interval);
            interval = '';
            apex.event.trigger('#' + itemName, EVENT_INTERVAL_OVER);
        };

    };

    let getCamelCase = function (word, firstCap = false) {
        let arr = word.split('-');
        let part, result = '';

        if (arr.length < 1) {
            return result;
        };

        if (firstCap) {
            arr[0] = arr[0][0].toUpperCase() + arr[0].substr(1);
        }

        for (let i = 0; i < arr.length; i++) {
            part = arr[i];
            if (i > 0) {
                part = part[0].toUpperCase() + part.substring(1);
            }
            result += part;
        }
        return result;
    }

    let getShape = function (shape) {
        if (shape == 'custom') {
            return 'Path';
        } else {
            return getCamelCase(shape, true);
        }
    }

    let getCls = function (pct, msg) {
        let result;
        if (pct == 'on-element' || msg == 'on-element') {
            result = 'fos-prb-on-element';
        } else {
            if (pct == 'above-element') {
                result = 'fos-prb-above-element';
            } else {
                result = 'fos-prb-below-element';
            }
        }
        return result;
    }

    let computeValue = function (itemName, value) {
        let valueNum = parseInt(value) || 0;
        if (valueNum >= MAX_VALUE) {
            return MAX_VALUE;
        } else if (valueNum <= MIN_VALUE) {
            return MIN_VALUE
        } else {
            return valueNum;
        }
    }

    let getPct = function (itemName, value = 0) {
        let pct = parseInt(value) <= 1 ? Math.round(value * 100) : value;
        return computeValue(itemName, pct);
    }

    return {
        init
    }
})()

