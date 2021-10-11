<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath =request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
    <script src="ECharts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>

    <script type="text/javascript">
        $(function () {
            //在页面加载完毕后，绘制统计图表
            getCharts();
        })
        function getCharts(){

  /*          $.ajax({
                url : "workbench/transaction/getActivityCharts.do",
                type : "GET",
                dataType : "json",
                success : function (data) {  }
                })*/

                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    // 指定图表的配置项和数据
            const axisData = ['Mon', 'Tue', 'Wed', 'Very Loooong Thu', 'Fri', 'Sat', 'Sun'];
            const data = axisData.map(function (item, i) {
                return Math.round(Math.random() * 1000 * (i + 1));
            });
            const links = data.map(function (item, i) {
                return {
                    source: i,
                    target: i + 1
                };
            });
            links.pop();
            option = {
                title: {
                    text: 'Graph on Cartesian'
                },
                tooltip: {},
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: axisData
                },
                yAxis: {
                    type: 'value'
                },
                series: [
                    {
                        type: 'graph',
                        layout: 'none',
                        coordinateSystem: 'cartesian2d',
                        symbolSize: 40,
                        label: {
                            show: true
                        },
                        edgeSymbol: ['circle', 'arrow'],
                        edgeSymbolSize: [4, 10],
                        data: data,
                        links: links,
                        lineStyle: {
                            color: '#2f4554'
                        }
                    }
                ]
            };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);

        }
    </script>
</head>
<body>

        <!-- 为 ECharts 准备一个定义了宽高的 DOM -->
        <div id="main" style="width: 800px;height:600px;"></div>
</body>
</html>
