package com.nguyenxb.crm.workbench.web.controller;

import com.nguyenxb.crm.exception.TranException;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.settings.service.UserService;
import com.nguyenxb.crm.settings.service.impl.UserServiceImpl;
import com.nguyenxb.crm.util.DateTimeUtil;
import com.nguyenxb.crm.util.PrintJson;
import com.nguyenxb.crm.util.ServiceFactory;
import com.nguyenxb.crm.util.UUIDUtil;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.Tran;
import com.nguyenxb.crm.workbench.domain.TranHistory;
import com.nguyenxb.crm.workbench.service.CustomerService;
import com.nguyenxb.crm.workbench.service.Impl.CustomerServiceImpl;
import com.nguyenxb.crm.workbench.service.Impl.TranServiceImpl;
import com.nguyenxb.crm.workbench.service.TranService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到交易控制器");
        String path = request.getServletPath();
        System.out.println(path);

        if ("/workbench/transaction/add.do".equals(path)) {
            add(request, response);
        } else if ("/workbench/transaction/getCustomerName.do".equals(path)) {
            getCustomerName(request, response);
        } else if ("/workbench/transaction/save.do".equals(path)) {
            save(request, response);
        } else if ("/workbench/transaction/detail.do".equals(path)) {
            detail(request, response);
        } else if ("/workbench/transaction/getHistoryListByTranId.do".equals(path)) {
            getHistoryListByTranId(request, response);
        } else if ("/workbench/transaction/changeStage.do".equals(path)) {
            changeStage(request, response);
        } else if ("/workbench/transaction/getCharts.do".equals(path)) {
            getCharts(request, response);
        } else if ("/workbench/transaction/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/transaction/deleteByArray.do".equals(path)) {
            deleteByArray(request, response);
        } else if ("/workbench/transaction/update.do".equals(path)) {
            update(request, response);
        } else if ("/workbench/transaction/edit.do".equals(path)) {
            edit(request, response);
        }

    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转到交易更新页的操作");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = us.getUserList();
        String id = request.getParameter("id");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Map<String,Object> map = null;
        try {
            map = tranService.edit(id);
        } catch (TranException e) {
            e.printStackTrace();
        }
        request.setAttribute("uList", userList);
        request.setAttribute("data",map);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request, response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入到交易的更新操作");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setNextContactTime(nextContactTime);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setSource(source);
        t.setStage(stage);
        t.setType(type);
        t.setActivityId(activityId);
        t.setContactsId(contactsId);
        t.setContactSummary(contactSummary);
        t.setDescription(description);
        t.setEditBy(editBy);
        t.setEditTime(editTime);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = ts.update(t, customerName);
        if (flag) {
            //如果添加交易成功，跳转到列表页
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }
    }

    private void deleteByArray(HttpServletRequest request, HttpServletResponse response) {
        //接收参数
        String[] ids = request.getParameterValues("id");
        //调用业务层
        TranService tran = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = false;
        try {
            flag = tran.deleteByArray(ids);
        } catch (TranException e) {
            e.printStackTrace();
        }
        //将结果传回给前端
        PrintJson.printJsonFlag(response, flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String customerId = request.getParameter("customerId");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String contactsId = request.getParameter("contactsId");
        String pageNumberstr = request.getParameter("pageNumber");
        int pageNumber = Integer.valueOf(pageNumberstr);
        //每页展现的记录数
        String pageSizestr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizestr);
        //计算出略过的记录数
        int skipCount = (pageNumber - 1) * pageSize;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerId", customerId);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contactsId", contactsId);
        map.put("pageSize", pageSize);
        map.put("skipCount", skipCount);

        TranService service = (TranService) ServiceFactory.getService(new TranServiceImpl());
        paginationVO<Tran> vo = service.pageList(map);
        PrintJson.printJsonObj(response, vo);
    }

    private void getCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得交易阶段数量统计图表的数据");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        /*
            业务层为我们返回
            total
            dataList
            通过打包以上两项进行返回
         */
        Map<String, Object> map = ts.getCharts();
        PrintJson.printJsonObj(response, map);
    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行改变阶段的操作");
        String id = request.getParameter("id");
        String stage = request.getParameter("stage");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        Tran t = new Tran();
        t.setId(id);
        t.setStage(stage);
        t.setMoney(money);
        t.setExpectedDate(expectedDate);
        t.setEditBy(editBy);
        t.setEditTime(editTime);
        Map<String, String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");
        t.setPossibility(pMap.get(stage));


        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = false;
        try {
            flag = ts.changeStage(t);
        } catch (TranException e) {
            e.printStackTrace();
        }
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("t", t);

        PrintJson.printJsonObj(response, map);
    }

    private void getHistoryListByTranId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据交易id取得相应的历史列表");
        String tranId = request.getParameter("tranId");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> thList = tranService.getHistoryListByTranId(tranId);
        //将交易历史列表遍历
        Map<String, String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");
        for (TranHistory th : thList) {
            //根据每一条交易历史取出每一个阶段
            String stage = th.getStage();
            String possibility = pMap.get(stage);
            th.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response, thList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到详细信息页");
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran t = ts.detail(id);
        //处理可能性
        /*
               阶段t
               阶段和可能性之间的对应关系 pMap
         */
        String stage = t.getStage();
        Map<String, String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(stage);
        t.setPossibility(possibility);
        request.setAttribute("t", t);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request, response);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入到交易的添加操作");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setNextContactTime(nextContactTime);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setSource(source);
        t.setStage(stage);
        t.setType(type);
        t.setActivityId(activityId);
        t.setContactsId(contactsId);
        t.setContactSummary(contactSummary);
        t.setDescription(description);
        t.setCreateBy(createBy);
        t.setCreateTime(createTime);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = false;
        try {
            flag = ts.save(t, customerName);
        } catch (TranException e) {
            e.printStackTrace();
        }
        if (flag) {
            //如果添加交易成功，跳转到列表页
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }
    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得客户名称列表（按照客户名称进行模糊查询）");
        String name = request.getParameter("name");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<String> sList = cs.getCustomerName(name);
        PrintJson.printJsonObj(response, sList);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转到交易添加页的操作");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = us.getUserList();
        request.setAttribute("uList", userList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request, response);
    }


}
