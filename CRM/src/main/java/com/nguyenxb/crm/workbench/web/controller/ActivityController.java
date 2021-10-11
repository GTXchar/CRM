package com.nguyenxb.crm.workbench.web.controller;

import com.nguyenxb.crm.exception.ActivityException;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.settings.service.UserService;
import com.nguyenxb.crm.settings.service.impl.UserServiceImpl;
import com.nguyenxb.crm.util.*;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.Activity;
import com.nguyenxb.crm.workbench.domain.ActivityRemark;
import com.nguyenxb.crm.workbench.service.ActivityService;
import com.nguyenxb.crm.workbench.service.Impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到市场活动控制器");
        String path = request.getServletPath();
        System.out.println(path);

        if("/workbench/activity/getUserList.do".equals(path)){
            getUserList(request,response);

        }else if ("/workbench/activity/save.do".equals(path)){
            save(request,response);
        }else if("/workbench/activity/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/activity/delete.do".equals(path)){
            delete(request,response);
        }else if("/workbench/activity/getUserListAndActivity.do".equals(path)){
            getUserListAndActivity(request,response);
        }else if("/workbench/activity/update.do".equals(path)){
            update(request,response);
        }else if("/workbench/activity/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/activity/getRemarkListByAid.do".equals(path)){
            getRemarkListByAid(request,response);
        }else if("/workbench/activity/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if("/workbench/activity/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if("/workbench/activity/editRemark.do".equals(path)){
            editRemark(request,response);
        }

    }

    private void editRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改备注信息的操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        ActivityRemark updateAR = new ActivityRemark();
        updateAR.setId(id);
        updateAR.setNoteContent(noteContent);
        updateAR.setEditTime(editTime);
        updateAR.setEditBy(editBy);
        updateAR.setEditFlag(editFlag);

        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = false;
        try {
            flag = service.updateRemark(updateAR);
        } catch (ActivityException e) {
            e.printStackTrace();
        }
        Map<String ,Object> map = new HashMap<String,Object>();
        map.put("success",flag);
        map.put("updateAR",updateAR);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到添加备注信息的操作");
        String noteContent = request.getParameter("noteContent");
        String activityId = request.getParameter("activityId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        ActivityRemark ar = new ActivityRemark();
        ar.setId(id);
        ar.setNoteContent(noteContent);
        ar.setActivityId(activityId);
        ar.setCreateTime(createTime);
        ar.setCreateBy(createBy);
        ar.setEditFlag(editFlag);
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = false;
        try {
            flag = service.saveRemark(ar);
        } catch (ActivityException e) {
            e.printStackTrace();
        }
        Map<String,Object> map = new HashMap<String ,Object>();
        map.put("success",flag);
        map.put("ar",ar);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注信息列表的操作");
        String id = request.getParameter("id");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean result = service.deleteRemarkById(id);
        PrintJson.printJsonFlag(response,result);
    }

    private void getRemarkListByAid(HttpServletRequest request,HttpServletResponse response) {
        System.out.println("进入到获取备注信息列表的操作");
        String Aid = request.getParameter("activityId");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> list = service.getRemarkListByAid(Aid);
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转到详细信息页的操作");
        String id = request.getParameter("id");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = service.detail(id);
        request.setAttribute("a",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改市场活动列表的操作");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        System.out.println("id========"+id);
        Activity a = new Activity();
        a.setId(id);
        a.setOwner(owner);
        a.setName(name);
        a.setStartDate(startDate);
        a.setEndDate(endDate);
        a.setCost(cost);
        a.setDescription(description);
        a.setEditTime(editTime);
        a.setEditBy(editBy);

        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = false;
        try {
            flag = service.updateActivityRemark(a);
        } catch (ActivityException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndActivity(HttpServletRequest request,HttpServletResponse response) {
        System.out.println("进入到查询用户信息列表和根据市场活动id查询单条记录的操作");
        String id = request.getParameter("id");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Map<String,Object> map = service.getUserListAndActivity(id);
        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request,HttpServletResponse response) {
        System.out.println("执行市场活动的删除操作");
        String ids[] = request.getParameterValues("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = false;
        try {
            flag = activityService.delete(ids);
        } catch (ActivityException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询市场活动信息列表的操作（结合条件查询和分页查询）");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String pageNumberstr = request.getParameter("pageNumber");
        int pageNumber = Integer.valueOf(pageNumberstr);
        //每页展现的记录数
        String pageSizestr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizestr);
        //计算出略过的记录数
        int skipCount = (pageNumber-1)*pageSize;

        Map<String,Object> map = new HashMap<String ,Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
      paginationVO<Activity> vo =  activityService.pageList(map);

      PrintJson.printJsonObj(response,vo);
        /*
        前端要：市场活动信息列表
                查询的总条数
                业务层拿到了以上两项信息之后，如果做返回
                map
                map.put("dataList":dataList)
                map.put("total":total)
                PrintJSON map --> json
                {"total":100,"dataList":[{市场活动1},{2},{3}]}

                vo
                PagenationVO<T>
                    private int total;
                    private List<T> dataList;

                PaginationVO<Activity> vo = new PaginationVO<>;
                vo.setTotal(total);
                vo.setDataList(dataList);
                PrintJSON vo --> json
                {"total":100,"dataList":[{市场活动1},{2},{3}]}
                    将来分页查询，每个模块都有，所以我们选择使用一个通用vo，操作起来比较方便
         */
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行市场活动添加操作");

         String id = UUIDUtil.getUUID();
         String owner = request.getParameter("owner");
         String name = request.getParameter("name");
         String startDate = request.getParameter("startDate");
         String endDate = request.getParameter("endDate");
         String cost = request.getParameter("cost");
         String description = request.getParameter("description");
         //创建时间：当前系统时间
         String createTime = DateTimeUtil.getSysTime();
         //创建人：当前登录用户
         String createBy = ((User) request.getSession().getAttribute("user")).getName();
        Activity activity = new Activity();
        activity.setId(id);
        activity.setCost(cost);
        activity.setStartDate(startDate);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setEndDate(endDate);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = false;
        try {
            flag = activityService.save(activity);
        } catch (ActivityException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request,HttpServletResponse response){
        System.out.println("取得用户信息列表");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = us.getUserList();
        System.out.println(userList);
        PrintJson.printJsonObj(response,userList);
    }

}
