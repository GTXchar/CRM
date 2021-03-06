package com.nguyenxb.crm.workbench.web.controller;

import com.nguyenxb.crm.exception.ContactsException;
import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.util.DateTimeUtil;
import com.nguyenxb.crm.util.PrintJson;
import com.nguyenxb.crm.util.ServiceFactory;
import com.nguyenxb.crm.util.UUIDUtil;
import com.nguyenxb.crm.vo.paginationVO;
import com.nguyenxb.crm.workbench.domain.*;
import com.nguyenxb.crm.workbench.service.*;
import com.nguyenxb.crm.workbench.service.Impl.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContactsController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        System.out.println(path);

        if ("/workbench/contacts/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/contacts/deleteByArray.do".equals(path)) {
            deleteByArray(request, response);
        }else if ("/workbench/contacts/getUserList.do".equals(path)) {
            getUserList(request, response);
        }else if ("/workbench/contacts/save.do".equals(path)) {
            save(request, response);
        }else if ("/workbench/contacts/getUserListAndContacts.do".equals(path)) {
            getUserListAndContacts(request, response);
        }else if ("/workbench/contacts/update.do".equals(path)) {
            update(request, response);
        }else if ("/workbench/contacts/detail.do".equals(path)) {
            detail(request, response);
        }else if ("/workbench/contacts/getRemarkListById.do".equals(path)) {
            getRemarkListById(request, response);
        }else if ("/workbench/contacts/editRemark.do".equals(path)) {
            editRemark(request, response);
        }else if ("/workbench/contacts/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        }else if ("/workbench/contacts/deleteRemark.do".equals(path)) {
            deleteRemark(request, response);
        }else if ("/workbench/contacts/getCustomerName.do".equals(path)) {
            getCustomerName(request, response);
        }else if ("/workbench/contacts/getActivityListByContactsId.do".equals(path)) {
            getActivityListByContactsId(request, response);
        }else if ("/workbench/contacts/unboundActivityById.do".equals(path)) {
            unboundActivityById(request, response);
        }else if ("/workbench/contacts/getActivityListByNameAndNotInContactsId.do".equals(path)) {
            getActivityListByNameAndNotInContactsId(request, response);
        }else if ("/workbench/contacts/bund.do".equals(path)) {
            bund(request, response);
        }else if ("/workbench/contacts/getContactsListByName.do".equals(path)) {
            getContactsListByName(request, response);
        }

    }

    private void getContactsListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("???????????????????????????????????????????????????");
        String cname = request.getParameter("cname");

        ContactsService as = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> aList = as.getContactsListByName(cname);
        PrintJson.printJsonObj(response,aList);
    }

    private void bund(HttpServletRequest request, HttpServletResponse response) {
        String cid = request.getParameter("cid");
        String[] aids = request.getParameterValues("aid");

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = false;
        try {
            flag = cs.bund(cid,aids);
        } catch (ContactsException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityListByNameAndNotInContactsId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("???????????????????????????????????????????????????+??????????????????????????????????????????");
        String aname = request.getParameter("aname");
        String contactsId = request.getParameter("contactsId");
//        System.out.println(clueId);
        Map<String ,String > map = new HashMap<String ,String >();
        map.put("aname",aname);
        map.put("contactsId",contactsId);
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = as.getActivityListByNameAndNotByContactsId(map);
        PrintJson.printJsonObj(response,aList);
    }

    private void unboundActivityById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("????????????????????????");
        String id = request.getParameter("id");
        ContactsService service = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = false;
        try {
            flag = service.unboundActivityById(id);
        } catch (ContactsException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityListByContactsId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("???????????????id?????????????????????????????????");
        String contactsId = request.getParameter("contactsId");
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = service.getActivityListByContactsId(contactsId);
        PrintJson.printJsonObj(response,aList);
    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("??????????????????????????????????????????????????????????????????");
        String name = request.getParameter("name");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<String> sList = cs.getCustomerName(name);
        PrintJson.printJsonObj(response, sList);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("?????????????????????????????????????????? ?????????");
        String id = request.getParameter("id");
        ContactsService service = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean result = false;
        try {
            result = service.deleteRemarkById(id);
        } catch (ContactsException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,result);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("????????????????????????????????????");
        String noteContent = request.getParameter("noteContent");
        String contactsId = request.getParameter("contactsId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        ContactsRemark cr = new ContactsRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setContactsId(contactsId);
        cr.setCreateTime(createTime);
        cr.setCreateBy(createBy);
        cr.setEditFlag(editFlag);
        ContactsService service = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = false;
        try {
            flag = service.saveRemark(cr);
        } catch (ContactsException e) {
            e.printStackTrace();
        }
        Map<String,Object> map = new HashMap<String ,Object>();
        map.put("success",flag);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void editRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("???????????????????????????????????? ?????????");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        ContactsRemark contactsRemark = new ContactsRemark();
        contactsRemark.setId(id);
        contactsRemark.setNoteContent(noteContent);
        contactsRemark.setEditTime(editTime);
        contactsRemark.setEditBy(editBy);
        contactsRemark.setEditFlag(editFlag);

        ContactsService service = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = false;
        try {
            flag = service.updateRemark(contactsRemark);
        } catch (ContactsException e) {
            e.printStackTrace();
        }
        Map<String ,Object> map = new HashMap<String,Object>();
        map.put("success",flag);
        map.put("updateCR",contactsRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("??????????????????????????????????????????");
        String Cid = request.getParameter("contactsId");
        ContactsService service = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<ContactsRemark> list = service.getRemarkListById(Cid);
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("??????????????? ???????????????????????????");
        //????????????id
        String id = request.getParameter("id");
        //??????id?????????????????????????????????,?????????????????????
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Contacts contacts = contactsService.getContactsById(id);
        //???clue????????????????????????request???????????????????????????detail??????
        request.setAttribute("contacts",contacts);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("???????????????????????????");
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        String id = request.getParameter("id");
        String fullname = request.getParameter("fullname");	//????????????????????????
        String appellation = request.getParameter("appellation");	//??????
        String owner = request.getParameter("owner");	//?????????
        String job = request.getParameter("job");	//??????
        String email = request.getParameter("email");	//??????
        String mphone = request.getParameter("mphone");	//??????
        String source = request.getParameter("source");	//??????
        String editBy = ((User) request.getSession().getAttribute("user")).getName();//?????????
        String editTime = DateTimeUtil.getSysTime();	//????????????
        String description = request.getParameter("description");	//??????
        String contactSummary = request.getParameter("contactSummary");	//????????????
        String nextContactTime = request.getParameter("nextContactTime");	//??????????????????
        String address = request.getParameter("address");	//??????
        String customerName = request.getParameter("customerName");	//??????
        String birth = request.getParameter("birth");	//??????

        Contacts contacts = new Contacts();
        contacts.setId(id);
        contacts.setFullname(fullname);
        contacts.setAppellation(appellation);
        contacts.setOwner(owner);
        contacts.setJob(job);
        contacts.setEmail(email);
        contacts.setMphone(mphone);
        contacts.setSource(source);
        contacts.setEditBy(editBy);
        contacts.setEditTime(editTime);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setNextContactTime(nextContactTime);
        contacts.setAddress(address);
        contacts.setBirth(birth);

        boolean flag = contactsService.update(contacts,customerName);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("?????? ???????????? ????????????");

        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        /* ?????? ?????? ?????? uList ??? Clue */
        Map<String,Object> map =  cs.getUserListAndContacts(id);

        PrintJson.printJsonObj(response,map);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("???????????????????????????");
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        String id = UUIDUtil.getUUID();	//??????
        String fullname = request.getParameter("fullname");	//????????????????????????
        String appellation = request.getParameter("appellation");	//??????
        String owner = request.getParameter("owner");	//?????????
        String job = request.getParameter("job");	//??????
        String email = request.getParameter("email");	//??????
        String mphone = request.getParameter("mphone");	//??????
        String source = request.getParameter("source");	//??????
        String createBy = ((User) request.getSession().getAttribute("user")).getName();//?????????
        String createTime = DateTimeUtil.getSysTime();	//????????????
        String description = request.getParameter("description");	//??????
        String contactSummary = request.getParameter("contactSummary");	//????????????
        String nextContactTime = request.getParameter("nextContactTime");	//??????????????????
        String address = request.getParameter("address");	//??????
        String customerName = request.getParameter("customerName");	//??????
        String birth = request.getParameter("birth");	//??????

        Contacts contacts = new Contacts();
        contacts.setId(id);
        contacts.setFullname(fullname);
        contacts.setAppellation(appellation);
        contacts.setOwner(owner);
        contacts.setJob(job);
        contacts.setEmail(email);
        contacts.setMphone(mphone);
        contacts.setSource(source);
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setNextContactTime(nextContactTime);
        contacts.setAddress(address);
        contacts.setBirth(birth);

        boolean flag = false;
        try {
            flag = contactsService.save(contacts,customerName);
        } catch (ContactsException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("????????????????????????");
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<User> userList = contactsService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

    private void deleteByArray(HttpServletRequest request, HttpServletResponse response) {
        //??????????????????id???
        String[] ids = request.getParameterValues("id");
        //???id?????????service???
        ContactsService con = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean flag = false;
        try {
            flag = con.deleteByArray(ids);
        } catch (ContactsException e) {
            e.printStackTrace();
        }
        PrintJson.printJsonFlag(response, flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("????????????????????????????????????");
        String fullname = request.getParameter("fullname");
        String owner = request.getParameter("owner");
        String customerId = request.getParameter("customerId");
        String source = request.getParameter("source");
        String birth = request.getParameter("birth");

        String pageNumberStr = request.getParameter("pageNumber");
        int pageNumber = Integer.valueOf(pageNumberStr);
        String pageSizeStr = request.getParameter("pageSize");

        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNumber - 1) * pageSize;

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("fullname", fullname);
        map.put("owner", owner);
        map.put("customerId", customerId);
        map.put("source", source);
        map.put("birth", birth);
        map.put("pageSize", pageSize);
        map.put("skipCount", skipCount);

        ContactsService service = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        paginationVO<Contacts> vo = service.pageList(map);
        PrintJson.printJsonObj(response, vo);
    }


}
