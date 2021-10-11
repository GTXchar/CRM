package com.nguyenxb.crm.web.listener;

import com.nguyenxb.crm.settings.domain.DicValue;
import com.nguyenxb.crm.settings.service.DicService;
import com.nguyenxb.crm.settings.service.impl.DicServiceImpl;
import com.nguyenxb.crm.util.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    /*
    event：该参数能够取得监听的对象
            监听的是什么对象，就可以通过该参数取得什么对象
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext application = sce.getServletContext();
        DicService ds = (DicService) ServiceFactory.getService(new DicServiceImpl());
        /*
            应该管业务层要7个list
            可以打包成为一个map
            业务层：
                map.put("appellationList",dvList1);
         */

        Map<String, List<DicValue>> map = ds.getAll();
        //将map解析为上下文域对象中保存的键值对
        Set<String> set = map.keySet();
        for(String key:set){
            application.setAttribute(key,map.get(key));
        }

        //------------------------------------------------
        //数据字典处理完毕后，处理Stage2Possibility.properties文件
        /*
            处理Stage2Possibility.properties文件步骤：
            1.解析该文件，将该属性文件中的键值对关系处理成为java中键值对关系（map）
                Map<String(阶段stage),String(可能性possibility)>pMap = ...
                pMap.put("01资质审查",10);
                ......
                pMap保存值以后，放在服务器缓存中
                application.setAttribute("pMap",pMap);
         */
        //解析properties文件
        Map<String ,String> pMap = new HashMap<String ,String>();
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> e = rb.getKeys();
        while (e.hasMoreElements()) {
            //阶段
            String key = e.nextElement();
            //可能性
            String value = rb.getString(key);

            pMap.put(key,value);
        }
        //将pMap保存到服务器缓存中
        application.setAttribute("pMap",pMap);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }
}
