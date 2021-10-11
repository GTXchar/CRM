package com.nguyenxb.crm.web.filter;

import com.nguyenxb.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
        System.out.println("进入到验证有没有登录过的过滤器");
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        HttpServletResponse httpServletResponse = (HttpServletResponse) response;

        String path = httpServletRequest.getServletPath();
        //不应该被拦截的资源，自动放行
        if("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            chain.doFilter(request,response);
        }else {
            HttpSession session = httpServletRequest.getSession();
            User user = (User) session.getAttribute("user");

            //如果user不为null，说明登录过
            if (user != null){
                chain.doFilter(request,response);
            }else {
                //其他资源必须验证有没有登陆过
                httpServletResponse.sendRedirect(httpServletRequest.getContextPath()+"/login.jsp");
            }
        }

    }
}
