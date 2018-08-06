<%@ page import="com.biz.lesson.model.student.subject" %>
<%@ page import="java.util.List" %>
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
        <link rel="stylesheet" href="static-resource/ace/assets/css/ace-skins.min.css" />
		<link rel="stylesheet" href="static-resource/ace/assets/css/ace-rtl.min.css" />

        <link rel="stylesheet" href="static-resource/ace/assets/css/bootstrap-duallistbox.min.css" />
		<link rel="stylesheet" href="static-resource/ace/assets/css/bootstrap-multiselect.min.css" />
		<link rel="stylesheet" href="static-resource/ace/assets/css/select2.min.css" />

		<!-- text fonts -->
		<link rel="stylesheet" href="static-resource/ace/assets/css/fonts.googleapis.com.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="static-resource/ace/assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />



        <script src="static-resource/ace/assets/js/jquery.gritter.min.js"></script>
        <script src="static-resource/ace/assets/js/bootstrap-editable.min.js"></script>
		<script src="static-resource/ace/assets/js/ace-editable.min.js"></script>
        <script src="static-resource/ace/assets/js/jquery.iframe-transport.js"></script>
        <script src="static-resource/ace/assets/js/jquery.fileupload.js"></script>
        <script src="static-resource/ace/assets/js/ace-extra.min.js"></script>
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
        <div class="row">
        <div class="form-group">


        <div class="hr hr-16 hr-dotted"></div>

        <div class="form-group">
            <div class="page-header">
                <h1>
                    学生信息
                    <small>
                        <i class="ace-icon fa fa-angle-double-right"></i>
                        选择课程
                    </small>
                </h1>
            </div><!-- /.page-header -->
        </div>
        </div>
        </div>


            <div class="form-group">

                <label class="col-sm-9 control-label no-padding-right" for="form-field-1"> 当前学生 </label>

                <div class="col-sm-9">
                    <input name= "gName" type="text" id="form-field-1" value="学生编号：${student.stuId}  学生姓名：${student.stuName}" readonly="readonly" class="col-xs-10 col-sm-5" />
                </div>
            </div>

            </br>
            </br>
            </br>


            <div class="col-sm-8">
                <h1>
                    未选择课程&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp 已选择课程
                </h1>

                <select multiple="multiple" size="10" name="duallistbox_demo1[]" id="duallist">
                    <c:forEach items="${subjects}" var="subject" >
                    <option value="${subject.subId}" <c:if test="${subject.students.containsAll([student])}" >selected="selected"</c:if> >
                            ${subject.subName}
                    </option>
                    </c:forEach>
                </select>
                <script type="text/javascript">
                    function yy() {
                        var tmp =$('[name="duallistbox_demo1[]"]').val();

                        alert("已选择的课程编号为："+($('[name="duallistbox_demo1[]"]').val())+"。   是否确定选择该课程");
                        window.location.href="joinSubject.do?temp="+tmp+"&stuId="+${stuId};
                    }
                </script>
                <div class="hr hr-16 hr-dotted"></div>
            </div>

        <div class="clearfix form-actions">
            <div class="col-md-offset-3 col-md-9">
                <button class="btn btn-info" type="submit" onclick="yy()">
                    <i class="ace-icon fa fa-check bigger-110"></i>
                    录入
                </button>

                &nbsp; &nbsp; &nbsp;
                <a href="chooseSubject.do?id=${student.stuId}">
                <button class="btn" type="reset">
                    <i class="ace-icon fa fa-undo bigger-110"></i>
                    查看选课状况
                </button>
                </a>
            </div>
        </div>




        <script src="static-resource/ace/assets/js/jquery-2.1.4.min.js"></script>

        <!-- <![endif]-->

        <!--[if IE]>
        <script src="static-resource/ace/assets/js/jquery-1.11.3.min.js"></script>
        <![endif]-->
        <script type="text/javascript">
            if('ontouchstart' in document.documentElement) document.write("<script src='static-resource/ace/assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
        </script>
        <script src="static-resource/ace/assets/js/bootstrap.min.js"></script>

        <!-- page specific plugin scripts -->
        <script src="static-resource/ace/assets/js/jquery.bootstrap-duallistbox.min.js"></script>
        <script src="static-resource/ace/assets/js/jquery.raty.min.js"></script>
        <script src="static-resource/ace/assets/js/bootstrap-multiselect.min.js"></script>
        <script src="static-resource/ace/assets/js/select2.min.js"></script>
        <script src="static-resource/ace/assets/js/jquery-typeahead.js"></script>

        <!-- ace scripts -->
        <script src="static-resource/ace/assets/js/ace-elements.min.js"></script>
        <script src="static-resource/ace/assets/js/ace.min.js"></script>

        <!-- inline scripts related to this page -->
        <script type="text/javascript">
            jQuery(function($){
                var demo1 = $('select[name="duallistbox_demo1[]"]').bootstrapDualListbox({infoTextFiltered: '<span class="label label-purple label-lg">Filtered</span>'});
                var container1 = demo1.bootstrapDualListbox('getContainer');
                //alert(demo);
                container1.find('.btn').addClass('btn-white btn-info btn-bold');

                /**var setRatingColors = function() {
					$(this).find('.star-on-png,.star-half-png').addClass('orange2').removeClass('grey');
					$(this).find('.star-off-png').removeClass('orange2').addClass('grey');
				}*/
                $('.rating').raty({
                    'cancel' : true,
                    'half': true,
                    'starType' : 'i'
                    /**,

                     'click': function() {
						setRatingColors.call(this);
					},
                     'mouseover': function() {
						setRatingColors.call(this);
					},
                     'mouseout': function() {
						setRatingColors.call(this);
					}*/
                })//.find('i:not(.star-raty)').addClass('grey');



                //////////////////
                //select2
                $('.select2').css('width','200px').select2({allowClear:true})
                $('#select2-multiple-style .btn').on('click', function(e){
                    var target = $(this).find('input[type=radio]');
                    var which = parseInt(target.val());
                    if(which == 2) $('.select2').addClass('tag-input-style');
                    else $('.select2').removeClass('tag-input-style');
                });

                //////////////////
                $('.multiselect').multiselect({
                    enableFiltering: true,
                    enableHTML: true,
                    buttonClass: 'btn btn-white btn-primary',
                    templates: {
                        button: '<button type="button" class="multiselect dropdown-toggle" data-toggle="dropdown"><span class="multiselect-selected-text"></span> &nbsp;<b class="fa fa-caret-down"></b></button>',
                        ul: '<ul class="multiselect-container dropdown-menu"></ul>',
                        filter: '<li class="multiselect-item filter"><div class="input-group"><span class="input-group-addon"><i class="fa fa-search"></i></span><input class="form-control multiselect-search" type="text"></div></li>',
                        filterClearBtn: '<span class="input-group-btn"><button class="btn btn-default btn-white btn-grey multiselect-clear-filter" type="button"><i class="fa fa-times-circle red2"></i></button></span>',
                        li: '<li><a tabindex="0"><label></label></a></li>',
                        divider: '<li class="multiselect-item divider"></li>',
                        liGroup: '<li class="multiselect-item multiselect-group"><label></label></li>'
                    }
                });


                ///////////////////

                //typeahead.js
                //example taken from plugin's page at: https://twitter.github.io/typeahead.js/examples/
                var substringMatcher = function(strs) {
                    return function findMatches(q, cb) {
                        var matches, substringRegex;

                        // an array that will be populated with substring matches
                        matches = [];

                        // regex used to determine if a string contains the substring `q`
                        substrRegex = new RegExp(q, 'i');

                        // iterate through the pool of strings and for any string that
                        // contains the substring `q`, add it to the `matches` array
                        $.each(strs, function(i, str) {
                            if (substrRegex.test(str)) {
                                // the typeahead jQuery plugin expects suggestions to a
                                // JavaScript object, refer to typeahead docs for more info
                                matches.push({ value: str });
                            }
                        });

                        cb(matches);
                    }
                }

                $('input.typeahead').typeahead({
                    hint: true,
                    highlight: true,
                    minLength: 1
                }, {
                    name: 'states',
                    displayKey: 'value',
                    source: substringMatcher(ace.vars['US_STATES']),
                    limit: 10
                });


                ///////////////


                //in ajax mode, remove remaining elements before leaving page
                $(document).one('ajaxloadstart.page', function(e) {
                    $('[class*=select2]').remove();
                    $('select[name="duallistbox_demo1[]"]').bootstrapDualListbox('destroy');
                    $('.rating').raty('destroy');
                    $('.multiselect').multiselect('destroy');
                });
            });
        </script>
    </jsp:body>
</lesson:page>