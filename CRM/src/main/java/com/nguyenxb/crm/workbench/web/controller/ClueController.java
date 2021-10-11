package com.nguyenxb.crm.workbench.web.controller;

import com.nguyenxb.crm.exception.ClueException;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.util.DateTimeUtil;
import com.nguyenxb.crm.util.PrintJson;
import com.nguyenxb.crm.util.ServiceFactory;
import com.nguyenxb.crm.util.UUIDUtil;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.*;
import com.nguyenxb.crm.workbench.service.ActivityService;
import com.nguyenxb.crm.workbench.service.ClueService;
import com.nguyenxb.crm.workbench.service.Impl.ActivityServiceImpl;
import com.nguyenxb.crm.workbench.service.Impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到线索控制器");
        String path = request.getServletPath();
        System.out.println(path);

        if ("/workbench/clue/getUserList.do".equals(path)) {
            getUserList(request, response);

        } else if ("/workbench/clue/save.do".equals(path)) {
            save(request, response);
        } else if ("/workbench/clue/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/clue/detail.do".equals(path)) {
            detail(request, response);
        } else if ("/workbench/clue/getActivityListByClueId.do".equals(path)){
            getActivityListByClueId(request, response);
        } else if("/workbench/clue/unboundActivityById.do".equals(path)){
            unboundActivityById(request,response);
        }else if("/workbench/clue/getActivityListByNameAndNotByClueId.do".equals(path)){
            getActivityListByNameAndNotByClueId(request,response);
        }else if("/workbench/clue/bund.do".equals(path)){
            bund(request,response);
        }else if("/workbench/clue/getActivityListByName.do".equals(path)){
            getActivityListByName(request,response);
        }else if("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }else if("/workbench/clue/delete.do".equals(path)){
            deleteByArray(request,response);
        }else if("/workbench/clue/getUserListAndClue.do".equals(path)){
            getUserListAndClue(request,response);
        }else if("/workbench/clue/update.do".equals(path)){
            update(request,response);
        }else if("/workbench/clue/getRemarkListById.do".equals(path)){
            getRemarkListById(request,response);
        }else if("/workbench/clue/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if("/workbench/clue/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if("/workbench/clue/editRemark.do".equals(path)){
            editRemark(request,response);
        }
    }

    private void editRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改备注信息的操作 线索");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        ClueRemark updateCR = new ClueRemark();
        updateCR.setId(id);
        updateCR.setNoteContent(noteContent);
        updateCR.setEditTime(editTime);
        updateCR.setEditBy(editBy);
        updateCR.setEditFlag(editFlag);

        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = false;
        try {
            flag = service.updateRemark(updateCR);
        } catch (ClueException e) {
            e.printStackTrace();
        }
        Map<String ,Object> map = new HashMap<String,Object>();
        map.put("success",flag);
        map.put("updateCR",updateCR);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注信息列表的操作 线索");
        String id = request.getParameter("id");
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean result = false;
        try {
            result = service.deleteRemarkById(id);
        } catch (ClueException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,result);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到添加备注信息的操作");
        String noteContent = request.getParameter("noteContent");
        String clueId = request.getParameter("clueId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        ClueRemark cr = new ClueRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setClueId(clueId);
        cr.setCreateTime(createTime);
        cr.setCreateBy(createBy);
        cr.setEditFlag(editFlag);
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = service.saveRemark(cr);
        Map<String,Object> map = new HashMap<String ,Object>();
        map.put("success",flag);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取备注信息列表的操作");
        String Cid = request.getParameter("clueId");
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<ClueRemark> list = service.getRemarkListById(Cid);
        PrintJson.printJsonObj(response,list);
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("执行修改线索操作");

        String id = req.getParameter("id");
        String fullname = req.getParameter("fullname");
        String appellation = req.getParameter("appellation");
        String owner = req.getParameter("owner");
        String company = req.getParameter("company");
        String job = req.getParameter("job");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String website = req.getParameter("website");
        String mphone = req.getParameter("mphone");
        String state = req.getParameter("state");
        String source = req.getParameter("source");
        String editBy = ((User)req.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        String description = req.getParameter("description");
        String contactSummary = req.getParameter("contactSummary");
        String nextContactTime = req.getParameter("nextContactTime");
        String address = req.getParameter("address");

        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);


//        System.out.println(clue);
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = false;
        try {
            flag = cs.update(clue);
        } catch (ClueException e) {
            e.printStackTrace();
        }

        PrintJson.printJsonFlag(resp,flag);
    }

    private void getUserListAndClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入 获取修改线索数据操作");

        String id = request.getParameter("id");
        ClueService as = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        /* 前端 需要 数据 uList 和 Clue */
        Map<String,Object> map =  as.getUserListAndClue(id);

        PrintJson.printJsonObj(response,map);
    }

    private void deleteByArray(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除操作");
        //获取前端传入的记录的id
        String[] ids = request.getParameterValues("id");
        //将ids传入Service
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = false;
        try {
            flag = cs.deleteByArray(ids);
        } catch (ClueException e) {
            e.printStackTrace();
        }
        //将结果响应回前端
        PrintJson.printJsonFlag(response,flag);
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行线索转换的");
        String clueId = request.getParameter("clueId");
        //接收是否需要创建交易的标记
        String flag = request.getParameter("flag");
        Tran t = null;
        //如果需要创建交易
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        if("a".equals(flag)){
            t = new Tran();
            //接收交易表单中的参数
            String id = UUIDUtil.getUUID();
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            String createTime = DateTimeUtil.getSysTime();

            t.setId(id);
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setActivityId(activityId);
            t.setCreateTime(createTime);
            t.setCreateBy(createBy);
        }
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag1 = false;
        try {
            flag1 = cs.convert(clueId,t,createBy);
        } catch (ClueException e) {
            e.printStackTrace();
        }
        if(flag1){
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }
    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询市场活动列表（根据名称模糊查询）");
        String aname = request.getParameter("aname");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
       List<Activity> aList = as.getActivityListByName(aname);
        PrintJson.printJsonObj(response,aList);
    }

    private void bund(HttpServletRequest request, HttpServletResponse response) {
        String cid = request.getParameter("cid");
        String[] aids = request.getParameterValues("aid");

        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = false;
        try {
            flag = cs.bund(cid,aids);
        } catch (ClueException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityListByNameAndNotByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询市场活动列表（根据名称模糊查询+排除掉已经关联指定线索的列表");
        String aname = request.getParameter("aname");
        String clueId = request.getParameter("clueId");
        System.out.println(clueId);
        Map<String ,String > map = new HashMap<String ,String >();
        map.put("aname",aname);
        map.put("clueId",clueId);
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = as.getActivityListByNameAndNotByClueId(map);
        PrintJson.printJsonObj(response,aList);
    }

    private void unboundActivityById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("解除关联市场活动");
        String id = request.getParameter("id");
        ClueService service = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = false;
        try {
            flag = service.unboundActivityById(id);
        } catch (ClueException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据线索id查询关联的市场活动信息");
        String ClueId = request.getParameter("clueId");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = service.getActivityListByClueId(ClueId);
        PrintJson.printJsonObj(response,aList);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到获取线索详细信息页面");
        //接收线索id
        String id = request.getParameter("id");
        //通过id查询该条线索的详细信息,封装成一个对象
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.getClueById(id);
        //将clue对象传给前端放入request域对象中，并转发到detail页面
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索信息列表的操作（结合条件查询和分页查询）");
        String fullname = request.getParameter("fullname");
        String company = request.getParameter("company");
        String phone = request.getParameter("phone");
        String source = request.getParameter("source");
        String owner = request.getParameter("owner");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String pageNumberstr = request.getParameter("pageNumber");
        int pageNumber = Integer.valueOf(pageNumberstr);
        //每页展现的记录数
        String pageSizestr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizestr);
        //计算出略过的记录数
        int skipCount = (pageNumber-1)*pageSize;


        Map<String,Object> map = new HashMap<String ,Object>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        paginationVO<Clue> vo =  clueService.pageList(map);

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
        System.out.println("执行线索添加操作");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        String id = UUIDUtil.getUUID();	//主键
        String fullname = request.getParameter("fullname");	//全名（人的名字）
        String appellation = request.getParameter("appellation");	//称呼
        String owner = request.getParameter("owner");	//所有者
        String company = request.getParameter("company");	//公司名称
        String job = request.getParameter("job");	//职业
        String email = request.getParameter("email");	//邮箱
        String phone = request.getParameter("phone");	//公司电话
        String website = request.getParameter("website");	//公司网站
        String mphone = request.getParameter("mphone");	//手机
        String state = request.getParameter("state");	//状态
        String source = request.getParameter("source");	//来源
        String createBy = ((User) request.getSession().getAttribute("user")).getName();//创建人
        String createTime = DateTimeUtil.getSysTime();	//创建时间
        String description = request.getParameter("description");	//描述
        String contactSummary = request.getParameter("contactSummary");	//联系纪要
        String nextContactTime = request.getParameter("nextContactTime");	//下次联系时间
        String address = request.getParameter("address");	//地址

        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);

        boolean flag = clueService.save(clue);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("获取用户信息列表");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<User> userList = clueService.getUserList();
        PrintJson.printJsonObj(response,userList);
     }
}
