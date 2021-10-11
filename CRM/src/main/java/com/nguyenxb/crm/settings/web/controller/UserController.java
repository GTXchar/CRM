package com.nguyenxb.crm.settings.web.controller;

import com.nguyenxb.crm.settings.domain.User;
import com.nguyenxb.crm.settings.service.UserService;
import com.nguyenxb.crm.settings.service.impl.UserServiceImpl;
import com.nguyenxb.crm.util.*;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到用户控制器");
        String path = request.getServletPath();
        System.out.println(path);
        if("/settings/user/login.do".equals(path)){
            //验证用户登录
            System.out.println("验证用户登录");
            login(request,response);
        }else if ("/settings/user/updatePwd.do".equals(path)){
            updatePwd(request,response);
        }
    }

    private void updatePwd(HttpServletRequest request, HttpServletResponse response) {
        //获取loginAct
        String loginId = ((User)request.getSession().getAttribute("user")).getId();
        //获取密码
        String oldPwd = request.getParameter("oldPwd");
        String newPwd = request.getParameter("newPwd");

        //验证旧密码,将密码转为加密状态
        oldPwd = MD5Util.getMD5(oldPwd);
        newPwd = MD5Util.getMD5(newPwd);

        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        boolean flag = userService.updataPwd(loginId,oldPwd,newPwd);

        PrintJson.printJsonFlag(response,flag);
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        //获取登录用户的用户名和密码
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码的明文显示转换为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接收ip地址
        String ip = GetIpUtil.getIpAddr(request);

        System.out.println(ip);
        //创建service对象,未来业务层的开发，统一使用代理类形态的接口对象
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());



        try{
            User user = userService.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);
            //如果程序执行到此处，说明业务层没有为controller抛出任何的异常
            //表示登录成功
            /*
            * {"success":true}
            */
            PrintJson.printJsonFlag(response,true);
        } catch (Exception e) {
            e.printStackTrace();
            //一旦程序执行了catch块的信息，说明业务层为我们验证登录失败，为controller抛出了异常
            //表示登录失败
            /*
            * {"success":false,"msg":?}
            */
            String msg = e.getMessage();
            /*
            * 我们现在作为controller，需要为ajax请求提供多项信息
            * 可以有两种手段来处理：
            *       1.将多项信息打包成为map，将map解析为json串
            *       2.创建一个Vo
            *           private boolean success;
            *           private String msg;
            * 如果对于展现的信息将来还会大量的使用，我们创建一个vo类，使用方便
            * 如果对于展现的信息只有在这个需求中能够使用，我们使用map就可以了
            */

            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }
}
