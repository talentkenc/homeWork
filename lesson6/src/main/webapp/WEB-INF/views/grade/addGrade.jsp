<%@page contentType="text/html; charset=utf-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="lesson" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="lessonTag" uri="http://com.biz.lesson/tag/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<lesson:page title="user.title.${cmd}">
    <jsp:attribute name="script">

        <link rel="stylesheet" href="static-resource/ace/assets/css/jquery.gritter.min.css" />
        <link rel="stylesheet" href="static-resource/ace/assets/css/bootstrap-editable.min.css" />
        <script src="static-resource/ace/assets/js/jquery.gritter.min.js"></script>
        <script src="static-resource/ace/assets/js/bootstrap-editable.min.js"></script>
		<script src="static-resource/ace/assets/js/ace-editable.min.js"></script>
        <script src="static-resource/ace/assets/js/jquery.iframe-transport.js"></script>
        <script src="static-resource/ace/assets/js/jquery.fileupload.js"></script>
		<script src="static-resource/ace/assets/js/bootstrap-datepicker.min.js"></script>
        <script src="static-resource/ace/assets/js/bootstrap-tag.min.js"></script>
        <script type="application/javascript">
            <c:forEach items="${admin.roles}" var="role" varStatus="status">
            var obj${status.count} = document.getElementById('roleId_${role.id}');
            if (obj${status.count}) obj${status.count}.checked = true;
            </c:forEach>
            jQuery(function ($) {
                $('.date-picker').datepicker({
                    autoclose: true,
                    format: 'yyyy-mm-dd',
                    todayHighlight: true,
                    zIndex: 999
                })
                //show datepicker when clicking on the icon
                    .next().on(ace.click_event, function () {
                    $(this).prev().focus();
                });



                editable();

                $("#password").on("blur",function () {
                    var reg = '(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,})$';

                    if($(this).val().match(reg)){
                        $("#confirm").attr('disabled',false);
                        return;
                    }else {
                        $("#confirm").attr('disabled',true);
                        layer.alert("<spring:message code='common.password.regexp'/> ");
                    }
                });

                bindTextChange( $("#emailPassword"));

                bindTextChange( $("#smtpServer"))



            });



            jQuery(document).ready(function () {
                var tag_input = $('#form-synonyms-tags');
                try {
                    tag_input.tag(
                        {
                            placeholder: tag_input.attr('placeholder')
                        }
                    )
                }
                catch (e) {
                    //display a textarea for old IE, because it doesn't support this plugin or another one I tried!
                    tag_input.after('<textarea id="' + tag_input.attr('id') + '" name="' + tag_input.attr('name') + '" rows="3">' + tag_input.val() + '</textarea>').remove();
                    //autosize($('#form-field-tags'));
                }
            });
            function doSubmit() {
                var cmd = $("#cmd").val();
                if (cmd == 'add') {
                    var pwd = $("#pwd").val();
                    var repeat = $("#repeat").val();
                    if (pwd != repeat) {
                        bootbox.alert('<spring:message code="user.info.passwordRepeatNotMatched"/>');
                        $("#pwd").select();
                        $("#pwd").focus();
                        return;
                    }
                }
                $("#admin-add-form").submit();
            };
            function checkUserNameExist() {
                var url = "manage/user/check.do?userId="+$('#userId').val();
                $.ajax({
                    url: url,
                    type: 'get',
                    success: function (result) {
                        updatePage(result);
                    }
                });
            }

            function updatePage(result) {
                if (result == true){
                    bootbox.alert('<spring:message code='users.valid.remote'/>');
                }
                if (result == false) {
                    bootbox.alert('<spring:message code='button.ok'/>');
                }
            }

            function editable() {
                $.fn.editable.defaults.mode = 'inline';
                $.fn.editableform.loading = "<div class='editableform-loading' ><i class='ace-icon fa fa-spinner fa-spin fa-2x light-blue'></i></div>";
                $.fn.editableform.buttons = '<button type="submit" class="btn btn-info editable-submit"><i class="ace-icon fa fa-check"></i></button>' +
                    '<button type="button" class="btn editable-cancel"><i class="ace-icon fa fa-times"></i></button>';

                // *** editable avatar *** //
                try {//ie8 throws some harmless exceptions, so let's catch'em

                    //first let's add a fake appendChild method for Image element for browsers that have a problem with this
                    //because editable plugin calls appendChild, and it causes errors on IE at unpredicted points
                    try {
                        document.createElement('IMG').appendChild(document.createElement('B'));
                    } catch (e) {
                        Image.prototype.appendChild = function (el) {
                        }
                    }

                    var last_gritter;
                    $('#avatar').editable({
                        type: 'image',
                        name: 'avatar',
                        value: null,
                        //onblur: 'ignore',  //don't reset or hide editable onblur?!
                        image: {
                            //specify ace file input plugin's options here
                            btn_choose: 'Change Avatar',
                            droppable: true,
                            maxSize: 2110000,//~2100Kb
                            //and a few extra ones here
                            name: 'file',//put the field name here as well, will be used inside the custom plugin
                            on_error: function (error_type) {//on_error function will be called when the selected file has a problem
                                if (last_gritter) $.gritter.remove(last_gritter);
                                if (error_type == 1) {//file format error
                                    last_gritter = $.gritter.add({
                                        title: 'File is not an image!',
                                        text: 'Please choose a jpg|gif|png image!',
                                        class_name: 'gritter-error gritter-center'
                                    });
                                } else if (error_type == 2) {//file size rror
                                    last_gritter = $.gritter.add({
                                        title: 'File too big!',
                                        text: 'Image size should not exceed 100Kb!',
                                        class_name: 'gritter-error gritter-center'
                                    });
                                }
                                else {//other error
                                }
                            },
                            on_success: function () {
                                $.gritter.removeAll();
                            }
                        },

                        url: function (params) {
                            // ***UPDATE AVATAR HERE*** //
                            //for a working upload example you can replace the contents of this function with
                            //examples/profile-avatar-update.js
                            console.log(params);
                            var deferred = new $.Deferred;

                            $("input[name='file']").prop('id', "file");
                            var value = $('#avatar').next().find('input[type=hidden]:eq(0)').val();

                            if (!value || value.length == 0) {
                                deferred.resolve();
                                return deferred.promise();
                            }

                            var data = new FormData($(".editableform")[0]);
                            $.ajax({
                                type: 'POST',
                                url: "file/upload.do",
                                dataType: 'json',
                                cache: false,
                                processData: false,    //需要正确设置此项
                                contentType: false,
                                enctype: '/form-data',    //需要正确设置此项
                                data: data,
                                success: function (data) {
                                    $('#logo').val(data.url);
                                    var form = $("#admin-add-form").serialize();
                                    $.post("manage/user/save_${cmd}.do", form, function (data) {

                                    });
                                    if ("FileReader" in window) {
                                        //for browsers that have a thumbnail of selected image
                                        var thumb = $('#avatar').next().find('img').data('thumb');
                                        if (thumb) $('#avatar').get(0).src = thumb;
                                    }

                                    deferred.resolve({'status': 'OK'});

                                    if (last_gritter) $.gritter.remove(last_gritter);
                                    last_gritter = $.gritter.add({
                                        title: '<spring:message code="prompt.update.success"/>',
                                        class_name: 'gritter-info gritter-left'
                                    });
                                },
                                error: function (XMLHttpRequest, textStatus, errorThrown) {
                                    alert('error:');
                                }
                            });

                            //dummy upload
//                        setTimeout(function () {
//                            if ("FileReader" in window) {
//                                //for browsers that have a thumbnail of selected image
//                                var thumb = $('#avatar').next().find('img').data('thumb');
//                                if (thumb) $('#avatar').get(0).src = thumb;
//                            }
//
//                            deferred.resolve({'status': 'OK'});
//
//                            if (last_gritter) $.gritter.remove(last_gritter);
//                            last_gritter = $.gritter.add({
//                                title: 'Avatar Updated!',
//                                text: 'Uploading to server can be easily implemented. A working example is included with the template.',
//                                class_name: 'gritter-info gritter-center'
//                            });
//
//                        }, 500);

                            return deferred.promise();

                            // ***END OF UPDATE AVATAR HERE*** //
                        },

                        success: function (response, newValue) {
                        }

                    });


                } catch (e) {
                }

            }

        </script>
    </jsp:attribute>
    <jsp:body>
        <body class="no-skin">
        <div class="page-header">
            <h1>
                学生信息
                <small>
                    <i class="ace-icon fa fa-angle-double-right"></i>
                    输入学生信息点击录入
                </small>
            </h1>
        </div><!-- /.page-header -->
        <div class="row">
            <div class="col-xs-12">
                <!-- PAGE CONTENT BEGINS -->
                <form action="addGrade.do" method="post" class="form-horizontal" role="form" onsubmit="return yanzheng()">
                    <script type="application/javascript">
                        function yanzheng(){// 当表单提交时触发的验证方法
                            var nameValue=window.document.getElementById("form-field-1").value;
                            if (nameValue == "") // 或者是!nameValue
                            {
                                window.alert("用户名不能为空!");
                                return false;
                            }
                            return true;
                        }
                    </script>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-field-1"> 班级名称 </label>
                        <div class="col-sm-9">
                            <input name= "gName" type="text" id="form-field-1" placeholder="班级名称" class="col-xs-10 col-sm-5" />
                        </div>
                    </div>
                    <div class="clearfix form-actions">
                        <div class="col-md-offset-3 col-md-9">
                            <button class="btn btn-info" type="submit">
                                <i class="ace-icon fa fa-check bigger-110"></i>
                                录入
                            </button>
                            &nbsp; &nbsp; &nbsp;
                            <button class="btn" type="reset">
                                <i class="ace-icon fa fa-undo bigger-110"></i>
                                重置
                            </button>
                        </div>
                    </div>
                </form>
            </div><!-- /.main-container -->

            <!-- basic scripts -->

            <!--[if !IE]> -->
            <script src="assets/js/jquery-2.1.4.min.js"></script>

            <!-- <![endif]-->

            <!--[if IE]>
            <script src="assets/js/jquery-1.11.3.min.js"></script>
            <![endif]-->
            <script type="text/javascript">
                if('ontouchstart' in document.documentElement) document.write("<script src='assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
            </script>
            <script src="assets/js/bootstrap.min.js"></script>

            <!-- page specific plugin scripts -->

            <!--[if lte IE 8]>
            <script src="assets/js/excanvas.min.js"></script>
            <![endif]-->
            <script src="assets/js/jquery-ui.custom.min.js"></script>
            <script src="assets/js/jquery.ui.touch-punch.min.js"></script>
            <script src="assets/js/chosen.jquery.min.js"></script>
            <script src="assets/js/spinbox.min.js"></script>
            <script src="assets/js/bootstrap-datepicker.min.js"></script>
            <script src="assets/js/bootstrap-timepicker.min.js"></script>
            <script src="assets/js/moment.min.js"></script>
            <script src="assets/js/daterangepicker.min.js"></script>
            <script src="assets/js/bootstrap-datetimepicker.min.js"></script>
            <script src="assets/js/bootstrap-colorpicker.min.js"></script>
            <script src="assets/js/jquery.knob.min.js"></script>
            <script src="assets/js/autosize.min.js"></script>
            <script src="assets/js/jquery.inputlimiter.min.js"></script>
            <script src="assets/js/jquery.maskedinput.min.js"></script>
            <script src="assets/js/bootstrap-tag.min.js"></script>

            <!-- ace scripts -->
            <script src="assets/js/ace-elements.min.js"></script>
            <script src="assets/js/ace.min.js"></script>

            <!-- inline scripts related to this page -->
            <script type="text/javascript">
                jQuery(function($) {
                    $('#id-disable-check').on('click', function() {
                        var inp = $('#form-input-readonly').get(0);
                        if(inp.hasAttribute('disabled')) {
                            inp.setAttribute('readonly' , 'true');
                            inp.removeAttribute('disabled');
                            inp.value="This text field is readonly!";
                        }
                        else {
                            inp.setAttribute('disabled' , 'disabled');
                            inp.removeAttribute('readonly');
                            inp.value="This text field is disabled!";
                        }
                    });



                    if(!ace.vars['touch']) {
                        $('.chosen-select').chosen({allow_single_deselect:true});
                        //resize the chosen on window resize

                        $(window)
                            .off('resize.chosen')
                            .on('resize.chosen', function() {
                                $('.chosen-select').each(function() {
                                    var $this = $(this);
                                    $this.next().css({'width': $this.parent().width()});
                                })
                            }).trigger('resize.chosen');
                        //resize chosen on sidebar collapse/expand
                        $(document).on('settings.ace.chosen', function(e, event_name, event_val) {
                            if(event_name != 'sidebar_collapsed') return;
                            $('.chosen-select').each(function() {
                                var $this = $(this);
                                $this.next().css({'width': $this.parent().width()});
                            })
                        });


                        $('#chosen-multiple-style .btn').on('click', function(e){
                            var target = $(this).find('input[type=radio]');
                            var which = parseInt(target.val());
                            if(which == 2) $('#form-field-select-4').addClass('tag-input-style');
                            else $('#form-field-select-4').removeClass('tag-input-style');
                        });
                    }


                    $('[data-rel=tooltip]').tooltip({container:'body'});
                    $('[data-rel=popover]').popover({container:'body'});

                    autosize($('textarea[class*=autosize]'));

                    $('textarea.limited').inputlimiter({
                        remText: '%n character%s remaining...',
                        limitText: 'max allowed : %n.'
                    });

                    $.mask.definitions['~']='[+-]';
                    $('.input-mask-date').mask('99/99/9999');
                    $('.input-mask-phone').mask('(999) 999-9999');
                    $('.input-mask-eyescript').mask('~9.99 ~9.99 999');
                    $(".input-mask-product").mask("a*-999-a999",{placeholder:" ",completed:function(){alert("You typed the following: "+this.val());}});



                    $( "#input-size-slider" ).css('width','200px').slider({
                        value:1,
                        range: "min",
                        min: 1,
                        max: 8,
                        step: 1,
                        slide: function( event, ui ) {
                            var sizing = ['', 'input-sm', 'input-lg', 'input-mini', 'input-small', 'input-medium', 'input-large', 'input-xlarge', 'input-xxlarge'];
                            var val = parseInt(ui.value);
                            $('#form-field-4').attr('class', sizing[val]).attr('placeholder', '.'+sizing[val]);
                        }
                    });

                    $( "#input-span-slider" ).slider({
                        value:1,
                        range: "min",
                        min: 1,
                        max: 12,
                        step: 1,
                        slide: function( event, ui ) {
                            var val = parseInt(ui.value);
                            $('#form-field-5').attr('class', 'col-xs-'+val).val('.col-xs-'+val);
                        }
                    });



                    //"jQuery UI Slider"
                    //range slider tooltip example
                    $( "#slider-range" ).css('height','200px').slider({
                        orientation: "vertical",
                        range: true,
                        min: 0,
                        max: 100,
                        values: [ 17, 67 ],
                        slide: function( event, ui ) {
                            var val = ui.values[$(ui.handle).index()-1] + "";

                            if( !ui.handle.firstChild ) {
                                $("<div class='tooltip right in' style='display:none;left:16px;top:-6px;'><div class='tooltip-arrow'></div><div class='tooltip-inner'></div></div>")
                                    .prependTo(ui.handle);
                            }
                            $(ui.handle.firstChild).show().children().eq(1).text(val);
                        }
                    }).find('span.ui-slider-handle').on('blur', function(){
                        $(this.firstChild).hide();
                    });


                    $( "#slider-range-max" ).slider({
                        range: "max",
                        min: 1,
                        max: 10,
                        value: 2
                    });

                    $( "#slider-eq > span" ).css({width:'90%', 'float':'left', margin:'15px'}).each(function() {
                        // read initial values from markup and remove that
                        var value = parseInt( $( this ).text(), 10 );
                        $( this ).empty().slider({
                            value: value,
                            range: "min",
                            animate: true

                        });
                    });

                    $("#slider-eq > span.ui-slider-purple").slider('disable');//disable third item


                    $('#id-input-file-1 , #id-input-file-2').ace_file_input({
                        no_file:'No File ...',
                        btn_choose:'Choose',
                        btn_change:'Change',
                        droppable:false,
                        onchange:null,
                        thumbnail:false //| true | large
                        //whitelist:'gif|png|jpg|jpeg'
                        //blacklist:'exe|php'
                        //onchange:''
                        //
                    });
                    //pre-show a file name, for example a previously selected file
                    //$('#id-input-file-1').ace_file_input('show_file_list', ['myfile.txt'])


                    $('#id-input-file-3').ace_file_input({
                        style: 'well',
                        btn_choose: 'Drop files here or click to choose',
                        btn_change: null,
                        no_icon: 'ace-icon fa fa-cloud-upload',
                        droppable: true,
                        thumbnail: 'small'//large | fit
                        //,icon_remove:null//set null, to hide remove/reset button
                        /**,before_change:function(files, dropped) {
						//Check an example below
						//or examples/file-upload.html
						return true;
					}*/
                        /**,before_remove : function() {
						return true;
					}*/
                        ,
                        preview_error : function(filename, error_code) {
                            //name of the file that failed
                            //error_code values
                            //1 = 'FILE_LOAD_FAILED',
                            //2 = 'IMAGE_LOAD_FAILED',
                            //3 = 'THUMBNAIL_FAILED'
                            //alert(error_code);
                        }

                    }).on('change', function(){
                        //console.log($(this).data('ace_input_files'));
                        //console.log($(this).data('ace_input_method'));
                    });


                    //$('#id-input-file-3')
                    //.ace_file_input('show_file_list', [
                    //{type: 'image', name: 'name of image', path: 'http://path/to/image/for/preview'},
                    //{type: 'file', name: 'hello.txt'}
                    //]);




                    //dynamically change allowed formats by changing allowExt && allowMime function
                    $('#id-file-format').removeAttr('checked').on('change', function() {
                        var whitelist_ext, whitelist_mime;
                        var btn_choose
                        var no_icon
                        if(this.checked) {
                            btn_choose = "Drop images here or click to choose";
                            no_icon = "ace-icon fa fa-picture-o";

                            whitelist_ext = ["jpeg", "jpg", "png", "gif" , "bmp"];
                            whitelist_mime = ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/bmp"];
                        }
                        else {
                            btn_choose = "Drop files here or click to choose";
                            no_icon = "ace-icon fa fa-cloud-upload";

                            whitelist_ext = null;//all extensions are acceptable
                            whitelist_mime = null;//all mimes are acceptable
                        }
                        var file_input = $('#id-input-file-3');
                        file_input
                            .ace_file_input('update_settings',
                                {
                                    'btn_choose': btn_choose,
                                    'no_icon': no_icon,
                                    'allowExt': whitelist_ext,
                                    'allowMime': whitelist_mime
                                })
                        file_input.ace_file_input('reset_input');

                        file_input
                            .off('file.error.ace')
                            .on('file.error.ace', function(e, info) {
                                //console.log(info.file_count);//number of selected files
                                //console.log(info.invalid_count);//number of invalid files
                                //console.log(info.error_list);//a list of errors in the following format

                                //info.error_count['ext']
                                //info.error_count['mime']
                                //info.error_count['size']

                                //info.error_list['ext']  = [list of file names with invalid extension]
                                //info.error_list['mime'] = [list of file names with invalid mimetype]
                                //info.error_list['size'] = [list of file names with invalid size]


                                /**
                                 if( !info.dropped ) {
							//perhapse reset file field if files have been selected, and there are invalid files among them
							//when files are dropped, only valid files will be added to our file array
							e.preventDefault();//it will rest input
						}
                                 */


                                //if files have been selected (not dropped), you can choose to reset input
                                //because browser keeps all selected files anyway and this cannot be changed
                                //we can only reset file field to become empty again
                                //on any case you still should check files with your server side script
                                //because any arbitrary file can be uploaded by user and it's not safe to rely on browser-side measures
                            });


                        /**
                         file_input
                         .off('file.preview.ace')
                         .on('file.preview.ace', function(e, info) {
						console.log(info.file.width);
						console.log(info.file.height);
						e.preventDefault();//to prevent preview
					});
                         */

                    });

                    $('#spinner1').ace_spinner({value:0,min:0,max:200,step:10, btn_up_class:'btn-info' , btn_down_class:'btn-info'})
                        .closest('.ace-spinner')
                        .on('changed.fu.spinbox', function(){
                            //console.log($('#spinner1').val())
                        });
                    $('#spinner2').ace_spinner({value:0,min:0,max:10000,step:100, touch_spinner: true, icon_up:'ace-icon fa fa-caret-up bigger-110', icon_down:'ace-icon fa fa-caret-down bigger-110'});
                    $('#spinner3').ace_spinner({value:0,min:-100,max:100,step:10, on_sides: true, icon_up:'ace-icon fa fa-plus bigger-110', icon_down:'ace-icon fa fa-minus bigger-110', btn_up_class:'btn-success' , btn_down_class:'btn-danger'});
                    $('#spinner4').ace_spinner({value:0,min:-100,max:100,step:10, on_sides: true, icon_up:'ace-icon fa fa-plus', icon_down:'ace-icon fa fa-minus', btn_up_class:'btn-purple' , btn_down_class:'btn-purple'});

                    //$('#spinner1').ace_spinner('disable').ace_spinner('value', 11);
                    //or
                    //$('#spinner1').closest('.ace-spinner').spinner('disable').spinner('enable').spinner('value', 11);//disable, enable or change value
                    //$('#spinner1').closest('.ace-spinner').spinner('value', 0);//reset to 0


                    //datepicker plugin
                    //link
                    $('.date-picker').datepicker({
                        autoclose: true,
                        todayHighlight: true
                    })
                    //show datepicker when clicking on the icon
                        .next().on(ace.click_event, function(){
                        $(this).prev().focus();
                    });

                    //or change it into a date range picker
                    $('.input-daterange').datepicker({autoclose:true});


                    //to translate the daterange picker, please copy the "examples/daterange-fr.js" contents here before initialization
                    $('input[name=date-range-picker]').daterangepicker({
                        'applyClass' : 'btn-sm btn-success',
                        'cancelClass' : 'btn-sm btn-default',
                        locale: {
                            applyLabel: 'Apply',
                            cancelLabel: 'Cancel',
                        }
                    })
                        .prev().on(ace.click_event, function(){
                        $(this).next().focus();
                    });


                    $('#timepicker1').timepicker({
                        minuteStep: 1,
                        showSeconds: true,
                        showMeridian: false,
                        disableFocus: true,
                        icons: {
                            up: 'fa fa-chevron-up',
                            down: 'fa fa-chevron-down'
                        }
                    }).on('focus', function() {
                        $('#timepicker1').timepicker('showWidget');
                    }).next().on(ace.click_event, function(){
                        $(this).prev().focus();
                    });




                    if(!ace.vars['old_ie']) $('#date-timepicker1').datetimepicker({
                        //format: 'MM/DD/YYYY h:mm:ss A',//use this option to display seconds
                        icons: {
                            time: 'fa fa-clock-o',
                            date: 'fa fa-calendar',
                            up: 'fa fa-chevron-up',
                            down: 'fa fa-chevron-down',
                            previous: 'fa fa-chevron-left',
                            next: 'fa fa-chevron-right',
                            today: 'fa fa-arrows ',
                            clear: 'fa fa-trash',
                            close: 'fa fa-times'
                        }
                    }).next().on(ace.click_event, function(){
                        $(this).prev().focus();
                    });


                    $('#colorpicker1').colorpicker();
                    //$('.colorpicker').last().css('z-index', 2000);//if colorpicker is inside a modal, its z-index should be higher than modal'safe

                    $('#simple-colorpicker-1').ace_colorpicker();
                    //$('#simple-colorpicker-1').ace_colorpicker('pick', 2);//select 2nd color
                    //$('#simple-colorpicker-1').ace_colorpicker('pick', '#fbe983');//select #fbe983 color
                    //var picker = $('#simple-colorpicker-1').data('ace_colorpicker')
                    //picker.pick('red', true);//insert the color if it doesn't exist


                    $(".knob").knob();


                    var tag_input = $('#form-field-tags');
                    try{
                        tag_input.tag(
                            {
                                placeholder:tag_input.attr('placeholder'),
                                //enable typeahead by specifying the source array
                                source: ace.vars['US_STATES'],//defined in ace.js >> ace.enable_search_ahead
                                /**
                                 //or fetch data from database, fetch those that match "query"
                                 source: function(query, process) {
						  $.ajax({url: 'remote_source.php?q='+encodeURIComponent(query)})
						  .done(function(result_items){
							process(result_items);
						  });
						}
                                 */
                            }
                        )

                        //programmatically add/remove a tag
                        var $tag_obj = $('#form-field-tags').data('tag');
                        $tag_obj.add('Programmatically Added');

                        var index = $tag_obj.inValues('some tag');
                        $tag_obj.remove(index);
                    }
                    catch(e) {
                        //display a textarea for old IE, because it doesn't support this plugin or another one I tried!
                        tag_input.after('<textarea id="'+tag_input.attr('id')+'" name="'+tag_input.attr('name')+'" rows="3">'+tag_input.val()+'</textarea>').remove();
                        //autosize($('#form-field-tags'));
                    }


                    /////////
                    $('#modal-form input[type=file]').ace_file_input({
                        style:'well',
                        btn_choose:'Drop files here or click to choose',
                        btn_change:null,
                        no_icon:'ace-icon fa fa-cloud-upload',
                        droppable:true,
                        thumbnail:'large'
                    })

                    //chosen plugin inside a modal will have a zero width because the select element is originally hidden
                    //and its width cannot be determined.
                    //so we set the width after modal is show
                    $('#modal-form').on('shown.bs.modal', function () {
                        if(!ace.vars['touch']) {
                            $(this).find('.chosen-container').each(function(){
                                $(this).find('a:first-child').css('width' , '210px');
                                $(this).find('.chosen-drop').css('width' , '210px');
                                $(this).find('.chosen-search input').css('width' , '200px');
                            });
                        }
                    })
                    /**
                     //or you can activate the chosen plugin after modal is shown
                     //this way select element becomes visible with dimensions and chosen works as expected
                     $('#modal-form').on('shown', function () {
					$(this).find('.modal-chosen').chosen();
				})
                     */



                    $(document).one('ajaxloadstart.page', function(e) {
                        autosize.destroy('textarea[class*=autosize]')

                        $('.limiterBox,.autosizejs').remove();
                        $('.daterangepicker.dropdown-menu,.colorpicker.dropdown-menu,.bootstrap-datetimepicker-widget.dropdown-menu').remove();
                    });

                });
            </script>
        </div>
        </body>
    </jsp:body>
</lesson:page>