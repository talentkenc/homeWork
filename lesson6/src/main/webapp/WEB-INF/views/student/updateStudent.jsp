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
            <form action="upStudent.do" method="post" class="form-horizontal" role="form" onsubmit="return yanzheng()">
                <script type="application/javascript">
                    function yanzheng(){// 当表单提交时触发的验证方法
                        if(!$("input[name='stuSex']").is(":checked")){//如果name为sex的input没有被选中
                            alert('请选择性别');//弹出提示
                            return false;// 返回假值表单不会提交
                        }else{
                            return true;// 返回真值表单提交
                        }
                    }
                </script>
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <div class="user-profile row col-sm-offset-3">
                            <div class="col-xs-4 col-sm-3">
                                <div class="widget-box">
                                    <div class="widget-header">
                                        <h4 class="widget-title">点击上传照片</h4>

                                        <div class="widget-toolbar">

                                            <a href="#" data-action="collapse">
                                                <i class="ace-icon fa fa-chevron-up"></i>

                                            </a>

                                            <a href="#" data-action="close">
                                                <i class="ace-icon fa fa-times"></i>

                                            </a>
                                        </div>
                                    </div>

                                    <div class="widget-body">
                                        <div class="widget-main">

                                            <div class="form-group">
                                                <div class="col-xs-12">

                                                    <input style= "background-image:url('assets/images/avatars/profile-pic.jpg')" type="file" id="id-input-file-3" accept="image/gif,image/jpeg,image/x-png" />

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    </br>
                        <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-field-1"> 学号 </label>
                        <div class="col-sm-9">
                        <input name= "stuId" value="${student.stuId}" readonly="readonly" type="text" id="form-field-1" placeholder="学号" class="col-xs-10 col-sm-5" />
                        </div>
                        </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="form-field-1"> 姓名 </label>
                        <div class="col-sm-9">
                            <input name="stuName" value="${student.stuName}" type="text" id="form-field-1" placeholder="姓名" class="col-xs-10 col-sm-5" />
                        </div>
                    </div>
                    <div class="space-4"></div>
                    <div class="form-group">
                        <div class="col-sm-4 control-label no-padding-right">
                            <div class="control-group">
                                <div class="radio">
                                    <label class="checkbox-inline">
                                        <input name="stuSex" value="男" type="radio" class="ace" />
                                        <span class="lbl"> 男</span>
                                    </label>
                                    <label class="checkbox-inline">
                                        <input name="stuSex" value="女" type="radio" class="ace" />
                                        <span class="lbl"> 女</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="name">
                            出生日期
                        </label>
                        <div class="widget-body">
                            <div class="widget-main">
                                <div class="row">
                                    <div class="col-xs-8 col-sm-3">
                                        <div class="input-group">
                                            <input name="stuBirthday" value="${student.birthday}" class="form-control date-picker" id="id-date-picker-1" type="text" data-date-format="dd-mm-yyyy" />
                                            <span class="input-group-addon">
																		<i class="fa fa-calendar bigger-110"></i>
																	</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">

                        <label class="col-sm-3 control-label no-padding-right" for="form-field-1"> 班级 </label>
                        <div class="col-sm-9">
                            <select name="stuGrade"  class="col-sm-3 control-label no-padding-right" id="form-field-select-3" data-placeholder="Choose a State...">
                                <c:forEach items="${grades}" var="grade">
                                    <option value="${grade.gId}">${grade.gName}</option>
                                </c:forEach>
                                    <%--<option value="1">书法班</option>--%>
                                    <%--<option value="2">语文班</option>--%>
                                    <%--<option value="3">数学班</option>--%>
                                    <%--<option value="4">IT班</option>--%>
                            </select>
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
    </jsp:body>
</lesson:page>