<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="decorator" content="whly" />
<style type="text/css">
	.control-label {
	    margin-top: 1px;
	    font-weight: 400;
	    text-align: right;
	    padding: 6px 0px;
	}
</style>
<script type="text/javascript">
			$(function() {
				//重置按钮
				$("#reset").click(resetFrom);
				//检索按钮
				$('#query').click(loadLine);
				// 加载统计图
				loadLine();
				
			});
			
			function loadLine() {
				var companyName = $('#nameQuery').val();
				var areaName = $('#areaQuery').val();
				var typeName = $('#industryQuery').val();
				var year = $('#timeQuery').val();
				var title = year.substring(0,5) + '01月~' + year.substring(5);
				var data = {
						statisticsType : 'MONTH', //统计类型
						year : year,			  //时间
						companyName : companyName,
						areaName : areaName,
						typeName : typeName
					};
				$.ajax({
					type : 'POST',
					data : data,
					url : whlyPath + '/reportstatistics/reportStatistics/getProportionQytb'
				}).done(function(result, status, xhr) {
					console.info(result.data);
					var psLineChar = echarts.init(document.getElementById('lineDiv'));
					if(!result.data[0].values) { //如果没数据 进行提示
						alert(title+areaName+typeName+companyName+ '没有数据，请重新选择！');
						psLineChar.clear();
						$('#query').button('reset'); //检索取消loading状态
						$('#query').dequeue();
						$('#reset').button('reset');//重置取消loading状态
						$('#reset').dequeue();
						return;
					}
					var data = result.data;
					var legendData =[];//图例
					var seriesData=[];//线
					var xAxisData=[];//日期
					if(areaName) {
						title = title + areaName;
					}
					if(typeName) {
						title = title + typeName;
					}
					if(companyName) {
						title = title + companyName;
					}
					title = title + '月份数据占比分析';
					$.each(data,function(index,item){
						legendData.push(item.name);
						var values=[];
						$.each(item.values,function(ind,it){
							if(index==0){
								xAxisData.push(it.name);
							};
							values.push(it.filed);
						});
						seriesData.push({
				            name:item.name,
				            type:'bar',
				            data: values
			       		});
					});
					
					var  option = {
	        		    title: {
	        		        text: title,
	        		        left: '30%',
	        		        textStyle: {
	        		            color: '#446699',
	        		            fontSize: '20',
	        		            align: 'center'
	        		        },
	        		    },
	        		    tooltip: {
	        		        trigger: 'axis',
	        		        axisPointer: {
	        		            type: 'shadow'
	        		        }
	        		    },
	        		    legend: {
	        		        data: legendData,
	        		        width:'330px',
	        		        height:'40px',
	        		        left: '3%'
	        		    },
	        		    grid: {
	        		    	top: '21%',
	        		        left: '3%',
	        		        right: '4%',
	        		        bottom: '3%',
	        		        containLabel: true
	        		    },
	        		    toolbox: {
	        		        show: true,
	        		        feature: {
	        		            mark: {show: true},
	        		            dataView: {show: true, readOnly: false},
	        		            magicType: {show: true, type: ['line', 'bar', 'stack', 'tiled']},
	        		            restore: {show: true},
	        		            saveAsImage: {show: true}
	        		        }
	        		    },
	        		    xAxis: {
	        		        type: 'category',
	        		        data: xAxisData,
	        		        axisTick: {show: false},
	        		        axisLine: {
       	                        show: true,
       	                        lineStyle: {type: 'solid'}
       	                    },
	        		    },
	        		    yAxis: [{
		        	        name : '金额(万元)',
	        	            type : 'value',
	        		        gridIndex: 0,
	        	            nameTextStyle: {
	        		            color: 'red',
	        		            fontSize: '12'
	        		        },
	        		        splitArea: {show: false},
        	                splitLine: {show: true,lineStyle:{type : 'dotted',color:"#445683"}},//网格线
	        	            max : 'dataMax',
	        	            min : 'dataMin'
	        	        },{
	        		    	type: "value",//坐标轴类型  'value' 数值轴，适用于连续数据 
        	                boundaryGap: [0, 0],//坐标轴两边留白策略，类目轴和非类目轴的设置和表现不一样
	        		        gridIndex: 0,
        	                axisLabel:{
        	                        formatter:'{value}',
        	                        interval:0,//为auto时会隐藏显示不了的X轴小标题
        	                        textStyle:{
        	                            color:'#333333'
        	                        }
        	                    },
       	                    axisLine:{
       	                        show:true,
       	                        lineStyle:{type : 'dotted',color:"#445683"}
       	                    },
	        		    }],
	        		    series: seriesData
	        		};
					psLineChar.setOption(option, true);
					loadPie(result.data);
					$('#query').button('reset'); //检索取消loading状态
					$('#query').dequeue();
					$('#reset').button('reset');//重置取消loading状态
					$('#reset').dequeue();
				}).fail(function(xhr, status, error) {
					window.location.href=whlyPath + '/home';
				}); 
			}
			
			function loadPie(data) {
				var pieDiv = $('#pieDiv');
				for (var i = 0; i < data.length; i++) {
					if($('#pieDiv > div').length < data.length+1) {
						var pie1 = pie.replace('[id]', 'pie' + i);
						pieDiv.append(pie1);
					}
					var pieChar = echarts.init(document.getElementById('pie' + i));
					var seriesData=[];//线
					var values=[];
					$.each(data[i].values,function(ind,it){
						if(it.filed>0) {
							var value = {
									name: it.name,
									value: it.filed
							}
							values.push(value);
						}
					});
					seriesData.push({
			            name:data[i].name,
			            type:'pie',
			            radius : '55%',
			            center: ['50%', '60%'],
			            data: values
		       		});
					console.info(seriesData);
					option = {
						    title : {
						        text: data[i].name + '占比',
						        left: '24%',
						        top: '20%',
						        textStyle: {
		        		            color: '#446699',
		        		            fontSize: '20'
		        		        },
						    },
						    toolbox: {
		        		        show: true,
		        		        top: '20%',
		        		        feature: {
		        		            restore: {show: true},
		        		            saveAsImage: {show: true}
		        		        }
		        		    },
						    tooltip : {
						        trigger: 'item',
						        formatter: "{a} <br/>{b} : {c} ({d}%)"
						    },
						    series : seriesData
						};
					
					pieChar.setOption(option, true);
					
					
				}
			}
			
			var pie = '<div class="chart col-md-3" id="[id]" style="height:350px;width:25%;"></div>';
			
			
        	//重置表单
			function resetFrom() {
        		var time = $('#year').attr('value');
				$("#timeQuery").val(time);
				$("#areaQuery").val("");
				$("#industryQuery").val("");
				$("#nameQuery").val("");
				loadLine();
			}
			
			
		</script>

</head>
<body>
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
				<div class="portlet-body">
					<form:form id="searchForm" modelAttribute="reportStatistics"
						action="${whlyPath}/reportstatistics/reportStatistics/getStatic?menuId=${menuId }"
						method="post" class="breadcrumb form-search">
						<input type="hidden" value="${companyParentType}" id="companyParentType">
						<input type="hidden" value="${reportStatistics.year }" id="year">
						<input type="hidden" value="1" name="month">
						<div class="row form-body">
							<div class="form-group col-md-3">
								<label class="control-label col-md-4" >时间：</label>
								<div class="col-md-8">
									<div class="input-group date date-picker"
										data-date-format="yyyy年mm月">
										<input type="text" class="form-control" readonly name="year"
											value="${reportStatistics.year }" id="timeQuery"> <span
											class="input-group-btn" >
											<button class="btn default date-set" type="button">
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group col-md-3">
								<label class="control-label col-md-4" >地区：</label>
								<div class="col-md-8">
									<form:select path="area.id" name="area.id" class="form-control"
										id="areaQuery">
										<form:option value="" label="全部" />
										<form:options
											items="${fnc:getArea('d233fe3d43da4d10ba0a7039746a47dd')}"
											itemLabel="name" itemValue="name" htmlEscape="false" />
									</form:select>
								</div>
							</div>
							<div class="form-group col-md-3">
								<label class="control-label col-md-4" >行业：</label>
								<div class="col-md-8">
									<form:select path="typeId" class="form-control" name="typeId"
										id="industryQuery">
										<form:option value="" label="全部" />
										<c:set var="industyTypeLable" value="${industyTypeLable}"/>
										<form:options items="${fns:getDictList(industyTypeLable)}"
											itemLabel="label" itemValue="label" htmlEscape="false" />
									</form:select>
								</div>
							</div>
							<div class="form-group col-md-3">
								<label class="control-label col-md-4" >企业名称：</label>
								<div class="col-md-8">
									<input class="form-control" type="text" placeholder=""
										name="companyName" value="${reportStatistics.companyName }" id="nameQuery">
								</div>
							</div>

						</div>
						<div class="row">
							
							<div class="form-group col-md-4">
								<div class="control-label col-md-3" ></div>
								<button class="btn demo-loading-btn green col-md-3" id="query" type="button" 
									style="margin-left: 12px;">检索</button>
								<div class="col-md-1"></div>
								<button class="btn green demo-loading-btn col-md-3" id="reset" type="button" >重置</button>
							</div>
						</div>
					</form:form> 
				</div>
				<!-- 主体部分START-->
				<div class="row" id="pieDiv">
					<div class=" chart" id="lineDiv" style="height:470px;width:100%;">
					
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
