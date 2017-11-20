<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="decorator" content="whly" />
<style>
/****************************table*******************************/
.table .gradeX td {
	
}

.table .gradeX td:last-child a {
	color: #333;
	padding: 0;
	font-size: 12px;
}

/*************************pagination***********************/
.pagination {
	/*background:#d00;*/
	width: 100%;
}

.pagination  ul li {
	list-style: none;
	float: left;
	margin: 0 1%;
}

.pagination  ul li a {
	float: left;
	width: 100%;
	color: #333;
}

.pagination  ul li:first-child {
	margin-left: 15%;
}

.pagination  ul .active a {
	text-decoration: underline;
}

.pagination  ul .disabled a {
	color: #ccc;
}

.pagination  ul .controls {
	margin-left: 5%;
	margin-top: -.3%;
}

.pagination  ul .controls input {
	width: 2em;
	outline: none;
}

.pagination  ul .controls a {
	color: #333;
}

.pagination  ul .controls a:hover {
	text-decoration: none;
}

</style>
<script type="text/javascript">
			$(function() {
				//重置按钮
				$("#reset").click(resetFrom);
				//导出按钮
				$("#export").click(Export);
				//删除多余元素
				$("#sample_1_length").remove();
				$("#sample_1_filter").remove();
				$("#sample_1_info").remove();
				$("#sample_1_paginate").remove();
			
				// 根据当前登录用户企业所属类型 来页面展示的内容
				contentShow();
				
				//如果有信息，则弹出
				if($('#message').val()){
					alert($('#message').val());
				}
			});
			
			// 根据当前登录用户企业所属类型 来页面展示的内容
			function contentShow() {
				var type = $('#companyParentType').val();
				if(type == "1") {
					$('.type_emphasis').show();
				} else if(type == "2") {
					$('.type_quota').show();
				} else if(type == "3") {
					$('.type_support').show();
				}
			}
			
			
        	//重置表单
			function resetFrom() {
				$("#timeQuery").val("");
				$("#staticQuery").val("");
				$("#regionQuery").val("");
				$("#industryQuery").val("");
				$("#nameQuery").val("");
				location.replace(whlyPath + '/report/frontCompanyReport/list?menuId=${menuId}');
			}
			
			//导出
			function Export() {
				$("#searchForm").attr("action", whlyPath + '/report/frontCompanyReport/export').submit();
				$("#searchForm").attr("action", whlyPath + '/report/frontCompanyReport/list?menuId=${menuId}');
			}
        	
        	//分页
			function page(n,s){
				$("#pageNo").val(n);
				$("#pageSize").val(s);
				$("#searchForm").submit();
	        	return false;
	        }
			
			
		</script>

</head>
<body
	class="page-header-fixed page-sidebar-closed-hide-logo page-content-white ">
	<div class="bootbox modal fade bootbox-alert in" tabindex="-1"
		role="dialog" style="display: none; padding-right: 16px;">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<button type="button" class="bootbox-close-button close"
						data-dismiss="modal" aria-hidden="true" style="margin-top: -10px;">×</button>
					<div class="bootbox-body">Hello world!</div>
				</div>
				<div class="modal-footer">
					<button data-bb-handler="ok" type="button" class="btn btn-primary">OK</button>
				</div>
			</div>
		</div>
	</div>
	<!-- BEGIN 顶部菜单  -->
	<%@ include file="../include/topmenu.jsp"%>
	<!-- END 顶部菜单  -->
	<!-- 不能删除下面一行 否则手机端样式错乱 -->
	<div class="clearfix"></div>
	<!-- 内容 -->
	<div class="page-container " id="main">
		<!-- modal-backdrop fade in -->
		<!-- BEGIN 左侧部分 -->
		<%@ include file="../include/leftmenu.jsp"%>
		<!-- END 左侧部分 -->

		<!-- BEGIN 右侧内容 -->
		<div class="page-content-wrapper ">
			<div class="page-content">
				<!-- page 菜单-->
				<%@ include file="../include/topBar.jsp"%>
				<!-- 主体部分START-->
				<div class="row">
					<div class="col-md-12">
						<input type="hidden" value="${companyParentType}" id="companyParentType">
						<input type="hidden" value="${message}" id="message">
						<!-- BEGIN EXAMPLE TABLE PORTLET-->
						<div class="portlet light bordered">
							<div class="portlet-title">
								<div class="caption font-dark">
									<i class="icon-settings font-dark"></i> <span
										class="caption-subject bold uppercase"> 数据列表</span>
								</div>
							</div>
							<div class="portlet-body">
								<table class="table table-striped table-bordered table-hover"
									id="sample_1">
									<thead>
										<tr role="row">
											<th>操作</th>
											<th>状态</th>
											<th>年</th>
											<th>月份</th>
											<th class="type_emphasis type_quota" style="display:none;">营业收入 (万元)</th>
											<th class="type_emphasis type_quota" style="display:none;">营业利润 (万元)</th>
											<th class="type_emphasis " style="display:none;">企业税费 (万元)</th>
											<th class="type_emphasis type_quota" style="display:none;">营业成本 (万元)</th>
											<th class="type_emphasis " style="display:none;">应付职工薪酬 (万元)</th>
											<th class="type_emphasis " style="display:none;">贷款金额 (万元)</th>
											<th class="type_emphasis " style="display:none;">订单数量 (个)</th>
											<th class="type_emphasis type_quota" style="display:none;">从业人数(人)</th>
											<th class="type_support" style="display:none;">项目名称</th>
											<th class="type_support" style="display:none;">总投资金额 (万元)</th>
											<th class="type_support" style="display:none;">贷款金额 (万元)</th>
											<th class="type_support" style="display:none;">起止年限</th>
											<th>上报时间</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${page.list}" var="frontCompanyReport">
											<tr class="gradeX odd" role="row">
												<td>
													<a style="color:#337ab7;" target="_blank"  href="${whlyPath}/report/frontCompanyReport/form?menuId=${menuId }&id=${frontCompanyReport.id}&from=view">查看</a>
													<a style="color:#337ab7;" target="_blank" href="${whlyPath}/report/frontCompanyReport/history?menuId=${menuId }&id=${frontCompanyReport.id}&from=view">历史</a>
												</td> 
												<td>${frontCompanyReport.statusName}</td>
												<td>${frontCompanyReport.year}</td>
												<td>${frontCompanyReport.month}</td>
												<td class="type_emphasis type_quota" style="display:none;">${frontCompanyReport.totalIncome}</td>
												<td class="type_emphasis type_quota" style="display:none;">${frontCompanyReport.totalProfit}</td>
												<td class="type_emphasis " style="display:none;">${frontCompanyReport.totalTax}</td>
												<td class="type_emphasis type_quota" style="display:none;">${frontCompanyReport.operatingCosts}</td>
												<td class="type_emphasis " style="display:none;">${frontCompanyReport.employeeCompensation}</td>
												<td class="type_emphasis " style="display:none;">${frontCompanyReport.loanAmount}</td>
												<td class="type_emphasis " style="display:none;">${frontCompanyReport.orderQuantity}</td>
												<td class="type_emphasis type_quota" style="display:none;">${frontCompanyReport.empQuantity}</td>
												<td class="type_support" style="display:none;">${frontCompanyReport.projectName}</td>
												<td class="type_support" style="display:none;">${frontCompanyReport.totalInvestment}</td>
												<td class="type_support" style="display:none;">${frontCompanyReport.bankLoanAmount}</td>
												<td class="type_support" style="display:none;">${frontCompanyReport.yearLimit}</td>
												<td><fmt:formatDate
														value="${frontCompanyReport.reportTime}"
														pattern="yyyy-MM-dd HH:mm:ss" /></td>
												
												
											</tr>
										</c:forEach>

									</tbody>
								</table>
								<div class="pagination">${page}</div>
							</div>
						</div>
					</div>
					<!-- END EXAMPLE TABLE PORTLET-->
				</div>
			</div>
			<!-- 主体部分END-->

			<div class="clearfix"></div>
		</div>
	</div>
	</div>

	<!-- END CONTAINER -->
	<!-- BEGIN FOOTER -->
	<%@ include file="../include/footer.jsp"%>
	<!-- js必须引用在body前面 -->
</body>
</html>

