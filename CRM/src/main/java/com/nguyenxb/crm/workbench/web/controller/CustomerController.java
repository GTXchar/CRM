package com.nguyenxb.crm.workbench.web.controller;

import com.nguyenxb.crm.exception.ContactsException;
import com.nguyenxb.crm.exception.CustomerException;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.util.DateTimeUtil;
import com.nguyenxb.crm.util.PrintJson;
import com.nguyenxb.crm.util.ServiceFactory;
import com.nguyenxb.crm.util.UUIDUtil;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.*;
import com.nguyenxb.crm.workbench.service.CustomerService;
import com.nguyenxb.crm.workbench.service.Impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到交易控制器");
        String path = request.getServletPath();
        System.out.println(path);

        if ("/workbench/customer/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/customer/getUserList.do".equals(path)) {
            getUserList(request,response);
        } else if ("/workbench/customer/deleteByArray.do".equals(path)) {
            deleteByArray(request, response);
        }else if ("/workbench/customer/save.do".equals(path)) {
            save(request, response);
        }else if ("/workbench/customer/getUserListAndCustomer.do".equals(path)) {
            getUserListAndCustomer(request, response);
        }else if ("/workbench/customer/update.do".equals(path)) {
            update(request, response);
        }else if ("/workbench/customer/detail.do".equals(path)) {
            detail(request, response);
        }else if ("/workbench/customer/getRemarkListById.do".equals(path)) {
            getRemarkListById(request, response);
        }else if ("/workbench/customer/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        }else if ("/workbench/customer/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        }else if ("/workbench/customer/editRemark.do".equals(path)) {
            editRemark(request, response);
        }

    }

    private void editRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改备注信息的操作 客户");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setId(id);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setEditTime(editTime);
        customerRemark.setEditBy(editBy);
        customerRemark.setEditFlag(editFlag);

        CustomerService service = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = false;
        try {
            flag = service.updateRemark(customerRemark);
        } catch (ContactsException e) {
            e.printStackTrace();
        } catch (CustomerException e) {
            e.printStackTrace();
        }
        Map<String ,Object> map = new HashMap<String,Object>();
        map.put("success",flag);
        map.put("updateCR",customerRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注信息列表的操作 客户");
        String id = request.getParameter("id");
        CustomerService service = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean result = false;
        try {
            result = service.deleteRemarkById(id);
        } catch (ContactsException e) {
            e.printStackTrace();
        } catch (CustomerException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,result);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到添加备注信息的操作");
        String noteContent = request.getParameter("noteContent");
        String customerId = request.getParameter("customerId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        CustomerRemark cr = new CustomerRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setCustomerId(customerId);
        cr.setCreateTime(createTime);
        cr.setCreateBy(createBy);
        cr.setEditFlag(editFlag);
        CustomerService service = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = false;
        try {
            flag = service.saveRemark(cr);
        } catch (ContactsException e) {
            e.printStackTrace();
        } catch (CustomerException e) {
            e.printStackTrace();
        }
        Map<String,Object> map = new HashMap<String ,Object>();
        map.put("success",flag);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取备注信息列表的操作");
        String Cid = request.getParameter("customerId");
        CustomerService service = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<CustomerRemark> list = service.getRemarkListById(Cid);
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到获取 客户详细信息页面");
        //接收线索id
        String id = request.getParameter("id");
        //通过id查询该条线索的详细信息,封装成一个对象
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Customer customer = customerService.getCustomerById(id);
        //将clue对象传给前端放入request域对象中，并转发到detail页面
        request.setAttribute("customer",customer);
        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改 客户信息");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        String editBy = ((User) request.getSession().getAttribute("user")).getName();//创建人
        String editTime = DateTimeUtil.getSysTime();
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String description = request.getParameter("description");
        String address = request.getParameter("address");


        Customer customer = new Customer();
        customer.setId(id);
        customer.setOwner(owner);
        customer.setName(name);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setEditBy(editBy);
        customer.setEditTime(editTime);
        customer.setContactSummary(contactSummary);
        customer.setNextContactTime(nextContactTime);
        customer.setDescription(description);
        customer.setAddress(address);

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        boolean flag = false;
        try {
            flag = customerService.update(customer);
        } catch (ContactsException e) {
            e.printStackTrace();
        } catch (CustomerException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入 获取修改 数据操作");

        String id = request.getParameter("id");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        /* 前端 需要 数据 uList 和 Customer */
        Map<String,Object> map =  cs.getUserListAndCustomer(id);

        PrintJson.printJsonObj(response,map);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("保存 客户信息");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("customerName");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();//创建人
        String createTime = DateTimeUtil.getSysTime();
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String description = request.getParameter("description");
        String address = request.getParameter("address");


        Customer customer = new Customer();
        customer.setId(id);
        customer.setOwner(owner);
        customer.setName(name);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setCreateBy(createBy);
        customer.setCreateTime(createTime);
        customer.setContactSummary(contactSummary);
        customer.setNextContactTime(nextContactTime);
        customer.setDescription(description);
        customer.setAddress(address);

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        boolean flag = false;
        try {
            flag = customerService.save(customer);
        } catch (ContactsException e) {
            e.printStackTrace();
        } catch (CustomerException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("获取用户信息列表");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<User> userList = customerService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

    private void deleteByArray(HttpServletRequest request, HttpServletResponse response) {
        //从前端接收参数
        String[] ids = request.getParameterValues("id");
        //将参数传入业务层处理
        CustomerService cus = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean flag = false;
        try {
            flag = cus.deleteByArray(ids);
        } catch (ContactsException e) {
            e.printStackTrace();
        } catch (CustomerException e) {
            e.printStackTrace();
        }
        //将处理结果传回给前端
        PrintJson.printJsonFlag(response, flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取客户分页信息操作");
        //获取查询信息
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String pageNumberstr = request.getParameter("pageNumber");
        int pageNumber = Integer.valueOf(pageNumberstr);
        //每页展现的记录数
        String pageSizestr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizestr);
        //计算出略过的记录数
        int skipCount = (pageNumber - 1) * pageSize;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);

        CustomerService cus = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        paginationVO<Customer> vo = cus.pageList(map);
        PrintJson.printJsonObj(response, vo);
    }


}
