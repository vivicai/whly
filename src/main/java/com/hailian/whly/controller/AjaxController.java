package com.hailian.whly.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.common.collect.Lists;
import com.hailian.whly.report.entity.FrontCompanyReport;
import com.hailian.whly.report.service.FrontCompanyReportService;
import com.hailian.whly.service.WhlyAccountService;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.Menu;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.service.SystemService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 
 * @className AjaxController.java
 * @time   2017年9月29日 下午5:16:29
 * @author zuoqb
 * @todo   TODO
 */
@Controller
@RequestMapping("${whlyPath}/ajax")
public class AjaxController extends BaseController {
	@Autowired
	private WhlyAccountService service;
	@Autowired
	private SystemService systemService;
	@Autowired
	private FrontCompanyReportService frontCompanyReportService;

    /**
     * 获取列表
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/getAccountList")
    public String getAccountList(HttpServletRequest request, HttpServletResponse response){
        try {
        	List<Menu> sourcelist = systemService.findAllFrontMenu();
            return resultSuccessData(response,"查询数据成功", sourcelist);
        } catch (Exception e) {
            return resultErrorData(response,"查询数据异常", null);
        }
    }
    /**
     * 
     * @time   2017年10月24日 上午11:42:37
     * @author zuoqb
     * @todo  按照状态、时间统计数量
     * @param  @param request
     * @param  @param response
     * @param  @param startDate
     * @param  @param endDate
     * @param  @return
     * @return_type   String
     */
    @RequestMapping(value = "/statisticsCountByStatus")
    public String statisticsCountByStatus(HttpServletRequest request, HttpServletResponse response,String startDate,String endDate){
        try {
        	Map<String, Object> params=new HashMap<String, Object>();
        	Calendar now = Calendar.getInstance();
    		Integer year = Integer.valueOf(now.get(1));
    		Integer month = Integer.valueOf(now.get(2))+1;
    		Integer day = Integer.valueOf(now.get(5));
    		if(Integer.valueOf(month) == 1) {
    			if(day <= 26) {
    				month = 12;
    				year = Integer.valueOf(year) - 1;
    			} 
    		} else {
    			if(day <= 26) {
    				month = Integer.valueOf(month) - 1;
    			} 
    		}
        	params.put("year",year);
        	params.put("month", month);
        	Office company= UserUtils.getUser().getCompany();
			if(company.getArea() != null && !company.getArea().getId().isEmpty()) {
				params.put("companyId", company.getParentId());
			} else {
				params.put("companyId", company.getId());
			}
        	List<FrontCompanyReport> sourcelist = frontCompanyReportService.statisticsCountByStatus(params);
            return resultSuccessData(response,"查询数据成功", sourcelist);
        } catch (Exception e) {
            return resultErrorData(response,"查询数据异常", null);
        }
    }
    /**
     * 
     * @time   2017年10月23日 下午5:14:14
     * @author zuoqb
     * @todo   按照时间（月份）统计企业上报数据
     * @param  @param request
     * @param  @param response
     * @param  @return
     * @return_type   String
     */
    @RequestMapping(value = "/statisticsReportByDateAjax")
    public String statisticsReportByDateAjax(HttpServletRequest request, HttpServletResponse response,String status){
        try {
        	String[] dateList=new String[12];
        	Calendar calendar = Calendar.getInstance();
        	String year=calendar.get(Calendar.YEAR)+"";
        	for(int x=1;x<13;x++){
        		String date=year;
        		if(x<10){
        			date+="/0"+x;
        		}else{
        			date+="/"+x;
        		}
        		dateList[x-1]=date;
        	}
        	Map<String, Object> params=new HashMap<String, Object>();
        	params.put("status", status);
        	params.put("dateList", dateList);
        	Office company= UserUtils.getUser().getCompany();
			if(company.getArea() != null && !company.getArea().getId().isEmpty()) {
				params.put("companyId", company.getParentId());
			} else {
				params.put("companyId", company.getId());
			}
        	List<FrontCompanyReport> sourcelist = frontCompanyReportService.statisticsReportByDate(params);
        	List<FrontCompanyReport> finalList=Lists.newArrayList();
        	for(String time:dateList){
        		String currentCount="0";
        		FrontCompanyReport ff=new FrontCompanyReport();
        		for(FrontCompanyReport f:sourcelist){
        			if(f.getName().equals(time)){
        				currentCount=f.getCount();
        				ff=f;
        				break;
        			}
        		}
        		ff.setName(time);
        		ff.setCount(currentCount);
        		finalList.add(ff);
        	}
            return resultSuccessData(response,"查询数据成功", finalList);
        } catch (Exception e) {
            return resultErrorData(response,"查询数据异常", null);
        }
    }
    /**
     * 
     * @time   2017年10月24日 下午1:31:45
     * @author zuoqb
     * @todo   按照行业类型统计数量
     * @param  @param request
     * @param  @param response
     * @return_type   String
     */
    @RequestMapping(value = "/statisticsCountByType")
    public String statisticsCountByType(HttpServletRequest request, HttpServletResponse response,String status){
        try {
        	String[] dateList=new String[12];
        	Calendar calendar = Calendar.getInstance();
        	String year=calendar.get(Calendar.YEAR)+"";
        	for(int x=1;x<13;x++){
        		String date=year;
        		if(x<10){
        			date+="/0"+x;
        		}else{
        			date+="/"+x;
        		}
        		dateList[x-1]=date;
        	}
        	Map<String, Object> params=new HashMap<String, Object>();
        	params.put("status",status);
        	params.put("dateList", dateList);
        	Office company= UserUtils.getUser().getCompany();
			if(company.getArea() != null && !company.getArea().getId().isEmpty()) {
				params.put("companyId", company.getParentId());
			} else {
				params.put("companyId", company.getId());
			}
        	List<FrontCompanyReport> sourcelist = frontCompanyReportService.statisticsCountByType(params);
            return resultSuccessData(response,"查询数据成功", sourcelist);
        } catch (Exception e) {
            return resultErrorData(response,"查询数据异常", null);
        }
    }
}
