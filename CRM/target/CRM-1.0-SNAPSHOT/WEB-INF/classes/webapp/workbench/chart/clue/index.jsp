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
            option = {
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b}: {c} ({d}%)'
                },
                legend: {
                    data: [
                        'Direct',
                        'Marketing',
                        'Search Engine',
                        'Email',
                        'Union Ads',
                        'Video Ads',
                        'Baidu',
                        'Google',
                        'Bing',
                        'Others'
                    ]
                },
                series: [
                    {
                        name: 'Access From',
                        type: 'pie',
                        selectedMode: 'single',
                        radius: [0, '30%'],
                        label: {
                            position: 'inner',
                            fontSize: 14
                        },
                        labelLine: {
                            show: false
                        },
                        data: [
                            { value: 1548, name: 'Search Engine' },
                            { value: 775, name: 'Direct' },
                            { value: 679, name: 'Marketing', selected: true }
                        ]
                    },
                    {
                        name: 'Access From',
                        type: 'pie',
                        radius: ['45%', '60%'],
                        labelLine: {
                            length: 30
                        },
                        label: {
                            formatter: '{a|{a}}{abg|}\n{hr|}\n  {b|{b}：}{c}  {per|{d}%}  ',
                            backgroundColor: '#F6F8FC',
                            borderColor: '#8C8D8E',
                            borderWidth: 1,
                            borderRadius: 4,
                            rich: {
                                a: {
                                    color: '#6E7079',
                                    lineHeight: 22,
                                    align: 'center'
                                },
                                hr: {
                                    borderColor: '#8C8D8E',
                                    width: '100%',
                                    borderWidth: 1,
                                    height: 0
                                },
                                b: {
                                    color: '#4C5058',
                                    fontSize: 14,
                                    fontWeight: 'bold',
                                    lineHeight: 33
                                },
                                per: {
                                    color: '#fff',
                                    backgroundColor: '#4C5058',
                                    padding: [3, 4],
                                    borderRadius: 4
                                }
                            }
                        },
                        data: [
                            { value: 1048, name: 'Baidu' },
                            { value: 335, name: 'Direct' },
                            { value: 310, name: 'Email' },
                            { value: 251, name: 'Google' },
                            { value: 234, name: 'Union Ads' },
                            { value: 147, name: 'Bing' },
                            { value: 135, name: 'Video Ads' },
                            { value: 102, name: 'Others' }
                        ]
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
