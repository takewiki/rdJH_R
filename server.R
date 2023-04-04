


#shinyserver start point----


shinyServer(function(input, output, session) {
  var_file_export_baseInfo = tsui::var_file('file_export_baseInfo')
  
  #预览功能处理 begin----                       
  shiny::observeEvent(input$btn_export_preview,
                      {
                        print('you click me ! ')
                        
                        #获取文件路径
                        file_name = var_file_export_baseInfo()          
                        print(file_name)
                        
                        #读取文件
                        data_excel <- readxl::read_excel(file_name)          
                        
                        #显示数据
                        tsui::run_dataTable2(id = 'dt_export_baseInfo',data = data_excel)           
                        
                        # 写入数据库
                        tsda::db_writeTable2(token = token,table_name = 'RDS_JH_T_receivables_his',
                                             r_object = data_excel,append = FALSE)
                        
                        # receivables_his_provisional
                        # sql_in = "INSERT INTO receivables_his  
                        #               SELECT *
                        #               from receivables_his_provisional a
                        #               where not exists
                        #               (select * from receivables_his b 
                        #                 where a.FBILLNO = b.FBILLNO 
                        #               )
                        #           "
                        # tsda::sql_gen_insert()
                        
                      })
  #预览功能处理 end----
  
  #更新功能处理 begin----
  shiny::observeEvent(input$btn_export_updateERP,
                      {
                        
                        # 获取文件路径
                        file_name = var_file_export_baseInfo()
                        
                        # 更新数据
                        rdjhpkg::pyrdjhmain(file_name, token)
                        
                        # 消息框提示
                        tsui::pop_notice('更新已成功')
                        
                        # 查询更新结果
                        dataisdo1 = rdjhpkg::pyrdjhres(token)
                        
                        # 下载数据
                        tsui::run_download_xlsx(id = 'dl_export_baseInfo',data =dataisdo1 ,filename = '结果对比.xlsx')
                      })
  #更新功能处理 end----
    
})
