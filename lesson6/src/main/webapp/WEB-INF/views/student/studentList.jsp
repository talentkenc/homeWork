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
                    学生列表
                </small>
            </h1>
        </div><!-- /.page-header -->
        <a href="add.do" class="btn btn-sm btn-primary"><i class="ace-icon glyphicon glyphicon-plus"></i>
            新增学生
        </a>
        <label>Search:<input type="search" id="searchByName" class="form-control input-sm" placeholder="" aria-controls="dynamic-table" onmouseout="search()"></label>
            <script type="application/javascript">
                function search() {
                    var val1 = $('#searchByName').val();
                    alert("是否搜索名称包含"+val1+"的学生");
                    window.location.href="search.do?searchName="+val1;
                }
            </script>
        <div class="col-xs-12">
            <table id="simple-table" class="table  table-bordered table-hover">
                <thead>
                <tr>
                    <th class="center">
                        <label class="pos-rel">
                            <input type="checkbox" class="ace" />
                            <span class="lbl"></span>
                        </label>
                    </th>
                    <th class="detail-col">详细信息</th>
                    <th>学号</th>
                    <th>姓名</th>
                    <th class="hidden-480">班级</th>
                    <th>
                        <i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i>
                        选修课数
                    </th>
                    <th class="hidden-480">平均成绩</th>
                    <th>选课</th>
                    <th>录分|&nbsp修改|&nbsp 删除</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${students}" var="student">
                <tr>
                    <td class="center">
                        <label class="pos-rel">
                            <input type="checkbox" class="ace" />
                            <span class="lbl"></span>
                        </label>
                    </td>

                    <td class="center">
                        <div class="action-buttons">
                            <a href="#" class="green bigger-140 show-details-btn" title="Show Details">
                                <i class="ace-icon fa fa-angle-double-down"></i>
                                <span class="sr-only">Details</span>
                            </a>
                        </div>
                    </td>

                    <td>
                        <a href="#">${student.stuId}</a>
                    </td>
                    <td>${student.stuName}</td>
                    <td class="hidden-480">${student.grade.gName}</td>
                    <td>${student.totalSubject}</td>

                    <td class="hidden-480">
                        <span class="label label-sm label-success">${student.avgScore}</span>
                    </td>

                    <td class="hidden-480">

                        <a href="chooseSubject.do?id=${student.stuId}">
                            <span class="blue2"><i class="ace-icon glyphicon glyphicon-list bigger-120"></i></span>
                        </a>

                    </td>

                    <td>
                        <div class="hidden-sm hidden-xs btn-group">
                            <a href="addScore.do?id=${student.stuId}">
                                <button class="btn btn-xs btn-success">
                                    <i class="ace-icon fa fa-check bigger-120"></i>
                                </button>
                            </a>
                            <a href="updateStudent.do?id=${student.stuId}">
                            <button class="btn btn-xs btn-info">
                                <i class="ace-icon fa fa-pencil bigger-120"></i>
                            </button>
                            </a>


                            <a data-id="${student.stuId}"
                                   data-url="delStudent.do" class="red btn-delete-modal">
                                <button class="btn btn-xs btn-info">
                                 <span class="red"><i class="ace-icon fa fa-trash-o bigger-120"></i></span>
                                </button>
                            </a>


                        </div>

                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-primary dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-cog icon-only bigger-110"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="#" class="tooltip-info" data-rel="tooltip" title="View">
																			<span class="blue">
																				<i class="ace-icon fa fa-search-plus bigger-120"></i>
																			</span>
                                        </a>
                                    </li>

                                    <li>
                                        <a href="#" class="tooltip-success" data-rel="tooltip" title="Edit">
																			<span class="green">
																				<i class="ace-icon fa fa-pencil-square-o bigger-120"></i>
																			</span>
                                        </a>
                                    </li>

                                    <li>
                                        <a href="#" class="tooltip-error" data-rel="tooltip" title="Delete">
																			<span class="red">
																				<i class="ace-icon fa fa-trash-o bigger-120"></i>
																			</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td>
                </tr>

                <tr class="detail-row">
                    <td colspan="8">
                        <div class="table-detail">
                            <div class="row">
                                <div class="col-xs-12 col-sm-2">
                                    <div class="text-center">
                                        <img height="150" class="thumbnail inline no-margin-bottom" alt="Domain Owner's Avatar" src="assets/images/avatars/profile-pic.jpg" />
                                        <br />
                                        <div class="width-80 label label-info label-xlg arrowed-in arrowed-in-right">
                                            <div class="inline position-relative">
                                                <a class="user-title-label" href="#">
                                                    <i class="ace-icon fa fa-circle light-green"></i>
                                                    &nbsp;
                                                    <span class="white">${student.stuName}</span>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-7">
                                    <div class="space visible-xs"></div>

                                    <div class="profile-user-info profile-user-info-striped">
                                        <div class="profile-info-row">
                                            <div class="profile-info-name"> 姓名 </div>

                                            <div class="profile-info-value">
                                                <span>${student.stuName}</span>
                                            </div>
                                        </div>

                                        <div class="profile-info-row">
                                            <div class="profile-info-name"> 性别 </div>

                                            <div class="profile-info-value">
                                                <span>${student.stuSex}</span>
                                            </div>
                                        </div>

                                        <div class="profile-info-row">
                                            <div class="profile-info-name"> 选修科目</div>

                                            <div class="profile-info-value">
                                                <span>
                                                    <%--${student.subjects.toString()}--%>
                                                    <c:forEach items="${sss}" var="ss">
                                                        <c:if test="${[student.stuId]==[ss.id.stu_Id]}">
                                                            <c:forEach items="${student.subjects}" var="subject">
                                                                <c:if test="${[subject.subId]==[ss.id.sub_Id]}">
                                                                   &nbsp ${subject.subName}:
                                                                    ${ss.score}
                                                                </c:if>
                                                            </c:forEach>

                                                        </c:if>
                                                    </c:forEach>
                                                </span>
                                            </div>
                                        </div>

                                        <%--<div class="profile-info-row">--%>
                                            <%--<div class="profile-info-name"> 平均成绩 </div>--%>

                                            <%--<div class="profile-info-value">--%>
                                                <%--<span>${student.avgScore}分</span>--%>
                                            <%--</div>--%>
                                        <%--</div>--%>

                                        <%--<div class="profile-info-row">--%>
                                            <%--<div class="profile-info-name"> Last Online </div>--%>

                                            <%--<div class="profile-info-value">--%>
                                                <%--<span>3 hours ago</span>--%>
                                            <%--</div>--%>
                                        <%--</div>--%>

                                        <%--<div class="profile-info-row">--%>
                                            <%--<div class="profile-info-name"> About Me </div>--%>

                                            <%--<div class="profile-info-value">--%>
                                                <%--<span>Bio</span>--%>
                                            <%--</div>--%>
                                        <%--</div>--%>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-3">
                                    <div class="space visible-xs"></div>
                                    <h4 class="header blue lighter less-margin">Send a message to Alex</h4>

                                    <div class="space-6"></div>

                                    <form>
                                        <fieldset>
                                            <textarea class="width-100" resize="none" placeholder="Type something…"></textarea>
                                        </fieldset>

                                        <div class="hr hr-dotted"></div>

                                        <div class="clearfix">
                                            <label class="pull-left">
                                                <input type="checkbox" class="ace" />
                                                <span class="lbl"> Email me a copy</span>
                                            </label>

                                            <button class="pull-right btn btn-sm btn-primary btn-white btn-round" type="button">
                                                Submit
                                                <i class="ace-icon fa fa-arrow-right icon-on-right bigger-110"></i>
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="dataTables_paginate paging_simple_numbers" id="dynamic-table_paginate">
                <ul class="pagination">
                    <li class="paginate_button previous" aria-controls="dynamic-table" tabindex="0"
                        id="dynamic-table_previous"><a href="studentList.do?page=${page=page-1}">上一页</a></li>
                    <li class="paginate_button " aria-controls="dynamic-table" tabindex="0"><a href="studentList.do?page=${page=1}">1</a></li>
                    <li class="paginate_button " aria-controls="dynamic-table" tabindex="0"><a href="studentList.do?page=${page=2}">2</a>
                    </li>
                    <li class="paginate_button " aria-controls="dynamic-table" tabindex="0"><a href="studentList.do?page=${page=3}">3</a></li>
                    <li class="paginate_button next" aria-controls="dynamic-table" tabindex="0"
                        id="dynamic-table_next"><a href="studentList.do?page=${page=page+1}">下一页</a></li>
                </ul>
            </div>
        </div><!-- /.span -->
    </jsp:body>
</lesson:page>