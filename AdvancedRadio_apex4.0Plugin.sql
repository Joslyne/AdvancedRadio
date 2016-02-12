set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040000 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,2933315405185630));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2010.05.13');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,999);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/au_jc_advanced_radio
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'AU.JC.ADVANCED_RADIO'
 ,p_display_name => 'Advanced Radio Group'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'--attribute_01 = num columns '||chr(10)||
'--attribute_02 = sort by (rows,columns)'||chr(10)||
'--attribute_03 = other Y/N'||chr(10)||
'--attribute_04 = Other - display label  default ''Other'' '||chr(10)||
'--attribute_05 = Other - return value default ''Other'' '||chr(10)||
'--attribute_06 = other on own line default false.  '||chr(10)||
'--attribute_07 = Allow final options to span columns'||chr(10)||
'--attribute_08 = placeholder value in apex 4'||chr(10)||
''||chr(10)||
'procedure start_option( l_total in numbe'||
'r  , p_item in apex_plugin.t_page_item , actual_total in number  ) is '||chr(10)||
''||chr(10)||
'num_cols number  :=   0; '||chr(10)||
'startcell boolean  := true; '||chr(10)||
'begin '||chr(10)||
''||chr(10)||
'    num_cols := p_item.attribute_01; '||chr(10)||
''||chr(10)||
''||chr(10)||
'    if apex_application.g_debug then '||chr(10)||
'      --wwv_flow.debug( ''START OPTION: total options   = ''||actual_total ||'' this option   = ''||l_total); '||chr(10)||
'      if p_item.attribute_02 = ''Rows'' then'||chr(10)||
'                wwv_flow.debug (''STAR'||
'T OPTION: this option = ''||l_total ||'', start new row on zero = '' || (mod( l_total ,  num_cols)  ) );'||chr(10)||
'      else '||chr(10)||
'                wwv_flow.debug (''START OPTION: this option = ''||l_total ||'', start new row on zero = '' || mod( l_total , ceil( actual_total  / num_cols ) )) ;'||chr(10)||
'      end if  ;'||chr(10)||
'    end if; '||chr(10)||
''||chr(10)||
'                   '||chr(10)||
'     if actual_total = l_total then'||chr(10)||
'        null ; '||chr(10)||
'     '||chr(10)||
'     elsif p_item.a'||
'ttribute_06  = ''Y'' and actual_total -1 = l_total  then '||chr(10)||
'       htp.p(''<tr><td style="vertical-align:top;" colspan="''||p_item.attribute_01||''">''); '||chr(10)||
'       wwv_flow.debug(''extra colspan'') ; '||chr(10)||
'       '||chr(10)||
'     else '||chr(10)||
''||chr(10)||
'       if p_item.attribute_02 = ''Rows''  then '||chr(10)||
'         if  mod( l_total  ,  num_cols  ) = 0 then -- start new row '||chr(10)||
'            htp.p('' <tr>''); '||chr(10)||
'         else -- start new column '||chr(10)||
'            '||
'null; '||chr(10)||
'         end if; '||chr(10)||
'       else  -- sort by columns '||chr(10)||
'         if  mod( l_total ,  ceil( actual_total  / num_cols) )  = 0    then -- start new column  '||chr(10)||
'            null ; '||chr(10)||
'         else -- continue current colunm '||chr(10)||
'             startcell := false ; '||chr(10)||
'         end if; '||chr(10)||
'       end if ; '||chr(10)||
'       '||chr(10)||
'       if startcell then '||chr(10)||
'         htp.p('' <td''||case '||chr(10)||
'                      when ( actual_total -1 = l_'||
'total and p_item.attribute_07 =''Y''  ) '||chr(10)||
'                      or ( actual_total - 2  = l_total and p_item.attribute_03 =''Y'' and p_item.attribute_07 =''Y'' and p_item.attribute_06 =''Y''  ) '||chr(10)||
'                       then '' colspan="''|| p_item.attribute_01  ||''"''  end ||''   style="vertical-align:top;"  >''  ); '||chr(10)||
'       end if; '||chr(10)||
'       '||chr(10)||
'     end if; '||chr(10)||
'    '||chr(10)||
'end ; '||chr(10)||
''||chr(10)||
'procedure end_option( l_total in number  , p_i'||
'tem in apex_plugin.t_page_item , actual_total in number  ) is '||chr(10)||
'l_column_value_list   apex_plugin_util.t_column_value_list; '||chr(10)||
'--actual_total number := 0; '||chr(10)||
'num_cols number  :=   0; '||chr(10)||
'startcell boolean  := true; '||chr(10)||
'begin '||chr(10)||
'    l_column_value_list :='||chr(10)||
'            apex_plugin_util.get_data ('||chr(10)||
'                p_sql_statement    => p_item.lov_definition,'||chr(10)||
'                p_min_columns      => 2,'||chr(10)||
'                '||
'p_max_columns      => 2,'||chr(10)||
'                p_component_name   => p_item.name);'||chr(10)||
''||chr(10)||
'    num_cols := p_item.attribute_01; '||chr(10)||
''||chr(10)||
'    if apex_application.g_debug then /*'||chr(10)||
'        wwv_flow.debug( ''END OPTION: total options   = ''||actual_total || '' this option   = ''||l_total  ); '||chr(10)||
'      if p_item.attribute_02 = ''Rows'' then'||chr(10)||
'                wwv_flow.debug ('' start new row on zero = '' || (mod( l_total ,  num_cols)  )'||
' );'||chr(10)||
'      else '||chr(10)||
'                 wwv_flow.debug ('' start new row on zero  = '' || mod( l_total ,  ceil( actual_total  / num_cols ) ) ) ;'||chr(10)||
'      end if  ;*/'||chr(10)||
'      '||chr(10)||
'      if p_item.attribute_02 = ''Rows'' then'||chr(10)||
'                wwv_flow.debug (''END OPTION  : this option = ''||l_total ||'', start new row on zero = '' || (mod( l_total ,  num_cols)  ) );'||chr(10)||
'      else '||chr(10)||
'                wwv_flow.debug (''END OPTION: '||
'this option = ''||l_total ||'', start new row on zero = '' || mod( l_total , ceil( actual_total  / num_cols ) )) ;'||chr(10)||
'      end if  ;'||chr(10)||
'    end if; '||chr(10)||
''||chr(10)||
''||chr(10)||
'     if actual_total = l_total then'||chr(10)||
'        htp.p(''</td></tr>''); '||chr(10)||
'     '||chr(10)||
'     elsif p_item.attribute_06  = ''Y'' and actual_total -1 = l_total  then '||chr(10)||
'       htp.p(''</td></tr>''); '||chr(10)||
'      '||chr(10)||
'     else '||chr(10)||
''||chr(10)||
'       if p_item.attribute_02 = ''Rows''  then '||chr(10)||
'         if  mod'||
'( l_total  ,  num_cols  ) = 0 then -- start new row '||chr(10)||
'            htp.p(''</td></tr>'');'||chr(10)||
'         else -- start new column '||chr(10)||
'            htp.p(''</td>'');'||chr(10)||
'         end if; '||chr(10)||
'       else  -- sort by columns '||chr(10)||
'         if  mod( l_total ,  ceil( actual_total  / num_cols) )  = 0    then -- start new column  '||chr(10)||
'            htp.p(''</td>''); '||chr(10)||
'         else -- continue current colunm '||chr(10)||
'             startcell := false'||
' ; '||chr(10)||
'         end if; '||chr(10)||
'       end if ; '||chr(10)||
'     end if; '||chr(10)||
'    '||chr(10)||
'end ; '||chr(10)||
''||chr(10)||
'procedure render_options( p_item  in apex_plugin.t_page_item,  p_value  in varchar2 , p_is_readonly in boolean ) '||chr(10)||
'is'||chr(10)||
'l_column_value_list   apex_plugin_util.t_column_value_list;'||chr(10)||
'l_selected boolean := false; '||chr(10)||
'  l_name          varchar2(30)    := apex_plugin.get_input_name_for_page_item(false);'||chr(10)||
'  l_total number := 0; '||chr(10)||
'  actual_total nu'||
'mber := 0;  '||chr(10)||
'  render_extra boolean := false;   '||chr(10)||
'  render_null  boolean := false;   '||chr(10)||
'  render_other boolean := false; '||chr(10)||
'  selected_value varchar2(1) ; '||chr(10)||
'  placeholder_value varchar2(2000) ; '||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  '||chr(10)||
'  -- set the placeholder '||chr(10)||
'  placeholder_value := p_item.attribute_08; '||chr(10)||
'  -- try to retrieve attribute_08'||chr(10)||
'  /*'||chr(10)||
'  begin '||chr(10)||
'   execute immediate '' '||chr(10)||
'     declare '||chr(10)||
'       ii apex_plugin.t_page_item; '||chr(10)||
'     beg'||
'in '||chr(10)||
'       ii := :b1 ; '||chr(10)||
'       :b2 := ii.attribute_08; '||chr(10)||
'     end; '||chr(10)||
'   '' using in p_item , out placeholder_value ;'||chr(10)||
'   exception when others then null; '||chr(10)||
'   end; '||chr(10)||
'   '||chr(10)||
'  -- try to retrieve placeholder  attribute '||chr(10)||
'  begin '||chr(10)||
'   execute immediate '' '||chr(10)||
'     declare '||chr(10)||
'       ii apex_plugin.t_page_item; '||chr(10)||
'     begin '||chr(10)||
'       ii := :b1 ; '||chr(10)||
'       :b2 := ii.placeholder; '||chr(10)||
'     end; '||chr(10)||
'   '' using in p_item , out placeho'||
'lder_value ;'||chr(10)||
'   exception when others then null; '||chr(10)||
'   end; '||chr(10)||
'*/ '||chr(10)||
'  '||chr(10)||
''||chr(10)||
'  l_column_value_list :='||chr(10)||
'        apex_plugin_util.get_data ('||chr(10)||
'            p_sql_statement    => p_item.lov_definition,'||chr(10)||
'            p_min_columns      => 2,'||chr(10)||
'            p_max_columns      => 2,'||chr(10)||
'            p_component_name   => p_item.name);'||chr(10)||
' '||chr(10)||
''||chr(10)||
'    actual_total := l_column_value_list(1).count ; '||chr(10)||
'    '||chr(10)||
'    /* decide which Options to re'||
'nder and now many there will be */ '||chr(10)||
'    '||chr(10)||
'    -- is the current value in the lov. '||chr(10)||
'    for i in 1 .. l_column_value_list(1).count'||chr(10)||
'    loop'||chr(10)||
'      if  p_value = l_column_value_list(2)(i) then '||chr(10)||
'         l_selected := true;  -- found it '||chr(10)||
'        wwv_flow.debug( '' item value found in lov.'');'||chr(10)||
'      else '||chr(10)||
'         wwv_flow.debug( '' item value not found in lov.'');'||chr(10)||
'      end if; '||chr(10)||
'    end loop; '||chr(10)||
'  '||chr(10)||
'    -- "O'||
'ther" option '||chr(10)||
'    if p_item.attribute_03 = ''Y''  then '||chr(10)||
'      actual_total :=  actual_total+1; '||chr(10)||
'      render_other:= true; '||chr(10)||
'      '||chr(10)||
'      if  p_value =  nvl(p_item.attribute_05 , ''Other'' )'||chr(10)||
'      then '||chr(10)||
'         l_selected := true; -- found it '||chr(10)||
'         selected_value := ''O'' ;'||chr(10)||
'      end if;       '||chr(10)||
'    end if; '||chr(10)||
''||chr(10)||
'    -- Null option '||chr(10)||
'    if p_item.lov_display_null   then '||chr(10)||
'      actual_total :=  actual_tot'||
'al+1; '||chr(10)||
'      render_null := true; '||chr(10)||
'      '||chr(10)||
'      if p_item.lov_null_value = p_value'||chr(10)||
'      or ( p_value is null and p_item.lov_null_value is null )'||chr(10)||
'      then '||chr(10)||
'        l_selected := true;  -- found it '||chr(10)||
'         selected_value := ''N'' ;'||chr(10)||
'       end if;'||chr(10)||
'    end if; '||chr(10)||
'    '||chr(10)||
'    -- extra value is enabled '||chr(10)||
'    if p_item.lov_display_extra '||chr(10)||
'    -- and  did not find a value in the LOV '||chr(10)||
'    and not l_selected '||chr(10)||
' '||
'   then '||chr(10)||
'      render_extra := true; '||chr(10)||
'      actual_total := actual_total + 1 ;'||chr(10)||
'         selected_value := ''E'' ;'||chr(10)||
'    end if; '||chr(10)||
'    '||chr(10)||
'    -- "Other" option '||chr(10)||
'    -- as a catchall when display extra is disabled and other is enabled '||chr(10)||
'    if render_other '||chr(10)||
'    and not p_item.lov_display_extra   '||chr(10)||
'    and p_value is not null '||chr(10)||
'    then       '||chr(10)||
'         l_selected := true; -- found it '||chr(10)||
'         selected_value :'||
'= ''O'' ;      '||chr(10)||
'    end if; '||chr(10)||
'   '||chr(10)||
'    '||chr(10)||
'    if apex_application.g_debug then '||chr(10)||
'      wwv_flow.debug('||chr(10)||
'          '' render_other = ''||case when render_other then ''Y'' else ''N'' end ||'||chr(10)||
'          '', render_extra = ''||case when render_extra then ''Y'' else ''N'' end ||'||chr(10)||
'          '', render_null  = ''||case when render_null then ''Y'' else ''N'' end ||'||chr(10)||
'          '', actual_total = ''||actual_total'||chr(10)||
'      ); '||chr(10)||
'    end if ; '||chr(10)||
' '||
'   '||chr(10)||
'    /**** Start rendering *****/ '||chr(10)||
'    '||chr(10)||
'    htp.p(''<tr><td>'');'||chr(10)||
' '||chr(10)||
' for i in 1 .. l_column_value_list(1).count'||chr(10)||
'    loop'||chr(10)||
'      if i > 1 then '||chr(10)||
'       start_option( l_total , p_item, actual_total  ) ; '||chr(10)||
'      end if; '||chr(10)||
'    '||chr(10)||
'        if apex_application.g_debug then'||chr(10)||
'            wwv_flow.debug( l_column_value_list(1)(i)||'',''||l_column_value_list(2)(i));'||chr(10)||
'        end if; '||chr(10)||
'        '||chr(10)||
'      if  p_value = l_col'||
'umn_value_list(2)(i) then '||chr(10)||
'         l_selected := true; '||chr(10)||
'      end if; '||chr(10)||
'    '||chr(10)||
'        sys.htp.p(''<div style="whitespace:no-wrap;" > ''||'||chr(10)||
'            ''<input type="radio"  style="margin:5px 3px 5px 5px; "  name="''||l_name||''"  ''||'||chr(10)||
'                   '' id="''||p_item.name||''_''||(i-1)||''" ''||'||chr(10)||
'                 /*    case when p_is_readonly then '' readonly="readonly" '' end || */   '||chr(10)||
'                     ''v'||
'alue="''||'||chr(10)||
'                           sys.htf.escape_sc(l_column_value_list(2)(i))||''"''|| -- value column'||chr(10)||
'                     case when p_value = l_column_value_list(2)(i) then  '' checked="checked" ''  '||chr(10)||
'                          when p_is_readonly then '' disabled="disabled" ''  end || '||chr(10)||
'                    '' ''||p_item.element_option_attributes||'' ''||'||chr(10)||
'            ''>''||'||chr(10)||
'            ''<label for="''||p_it'||
'em.name||''_''||(i-1)||''">''||sys.htf.escape_sc(l_column_value_list(1)(i))||''</label> '' ||-- display column '||chr(10)||
'            ''</div>'''||chr(10)||
'            );'||chr(10)||
'            '||chr(10)||
'       l_total := i; '||chr(10)||
'       end_option( l_total , p_item, actual_total  ) ; '||chr(10)||
'       '||chr(10)||
'    end loop;'||chr(10)||
'    '||chr(10)||
'    '||chr(10)||
'    l_total := l_column_value_list(1).count ; '||chr(10)||
''||chr(10)||
'    if render_extra then '||chr(10)||
''||chr(10)||
'      start_option( l_total , p_item, actual_total  ) ; '||chr(10)||
'   '||
'   '||chr(10)||
'        sys.htp.p(''<div style="whitespace:no-wrap;" > ''||'||chr(10)||
'        ''<input type="radio"    style="margin:5px 3px 5px 5px; "     name="''||l_name||''"  ''|| '||chr(10)||
'                ''id="''||p_item.name||''_''||l_total ||''" ''||'||chr(10)||
'               /* case when p_is_readonly then '' readonly="readonly" '' end || */ '||chr(10)||
'        '' value=''||sys.htf.escape_sc(p_value)|| ''" checked="checked" ''    || '' />''||'||chr(10)||
'        ''<label f'||
'or="''||p_item.name||''_''||l_total  ||''">''|| nvl(sys.htf.escape_sc(p_value), ''(null)'') ||''</label> ''||'||chr(10)||
'       ''</div>'''||chr(10)||
'        ); '||chr(10)||
'      l_total := l_total + 1; '||chr(10)||
'      end_option( l_total , p_item , actual_total  ) ; '||chr(10)||
'    end if; '||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'    --if p_item.lov_display_null  then'||chr(10)||
'    if render_null then '||chr(10)||
'    start_option( l_total , p_item, actual_total  ) ;  '||chr(10)||
'      '||chr(10)||
'        sys.htp.p(''<div style="whitespace'||
':no-wrap;" > ''||'||chr(10)||
'        ''<input type="radio"    style="margin:5px 3px 5px 5px; "   name="''||l_name||''"  id="''||p_item.name||''_''||l_total ||''" ''||'||chr(10)||
'          case when p_is_readonly then '' readonly="readonly" '' end || '||chr(10)||
'        '' value="''||nvl( sys.htf.escape_sc(p_item.lov_null_value), '''')|| ''" ''||'||chr(10)||
'          case '||chr(10)||
'              --when p_item.lov_null_value = p_value '||chr(10)||
'              --or ( p_value is '||
'null and p_item.lov_null_value is null ) '||chr(10)||
'              when selected_value = ''N''     '||chr(10)||
'              then   '' checked="checked" '' '||chr(10)||
'              when p_is_readonly then '' disabled="disabled" ''  end     || '||chr(10)||
'            '' />''||'||chr(10)||
'        ''<label for="''||p_item.name||''_''||l_total  ||''">''|| nvl( sys.htf.escape_sc(p_item.lov_null_text), ''Null'')  ||''</label> ''||'||chr(10)||
'       ''</div>'''||chr(10)||
'        ); '||chr(10)||
''||chr(10)||
'      l_total '||
':= l_total + 1; '||chr(10)||
'      end_option( l_total , p_item, actual_total  ) ; '||chr(10)||
'      '||chr(10)||
'    end if; '||chr(10)||
''||chr(10)||
'   if render_other then '||chr(10)||
''||chr(10)||
'     start_option( l_total , p_item, actual_total  ) ;  '||chr(10)||
'    '||chr(10)||
'    sys.htp.p(''<div style="whitespace:no-wrap;" > ''||'||chr(10)||
'        ''<input type="radio"   style="margin:5px 3px 5px 5px; "   name="''||l_name||''"  ''||'||chr(10)||
'                 case when p_is_readonly then '' readonly="readonly" '' end '||
'|| '||chr(10)||
'                 '' id="''||p_item.name||''_''||l_total  ||''" ''||'||chr(10)||
'               '' value''|| case '||chr(10)||
'                              --when not l_selected and p_value is not null '||chr(10)||
'                              when selected_value = ''O'' '||chr(10)||
'                              then ''="''||sys.htf.escape_sc(p_value) || ''" checked="checked" '' '||chr(10)||
'                              else ''="''||p_item.attribute_05|| ''" ''  -- d'||
'efault value for "Other" option. '||chr(10)||
'                          end   ||'||chr(10)||
'                 case when nvl(selected_value,''X'')   <> ''O'' and p_is_readonly   then '' disabled="disabled" '' end || '||chr(10)||
'         '' />''||'||chr(10)||
'        ''<label for="''||p_item.name||''_''||l_total ||''">''||p_item.attribute_04||''</label> '''||chr(10)||
'        ); '||chr(10)||
'        sys.htp.p('||chr(10)||
'          ''<input onChange=" var v = $(this).val(); var n = $(''''#''||p_item.'||
'name||''_''||l_total ||'''''');  n.val( v ) ;  "  ''||'||chr(10)||
'                ''  onKeyup=" var v = $(this).val(); var n = $(''''#''||p_item.name||''_''||l_total ||''''''); if (v.length > 0 ) n.prop(''''checked'''', true);  n.val( v ) ;  " ''||'||chr(10)||
'                   ''value="''|| case when /*not l_selected */ selected_value = ''O'' then  sys.htf.escape_sc(p_value)  end ||''" ''||'||chr(10)||
'                    '' class="advanced_radio_other_tex'||
't_input" size="''||p_item.element_width||''"  maxlength="''||p_item.element_max_length||''" ''||'||chr(10)||
'                     case when p_is_readonly then '' disabled="disabled" '' end || '||chr(10)||
'                    ''placeholder="''|| placeholder_value  ||''"''||'||chr(10)||
'             ''></input></div>'''||chr(10)||
'    );-- display column '||chr(10)||
'    '||chr(10)||
'      l_total := l_total + 1; '||chr(10)||
'    end_option( l_total , p_item, actual_total ) ;  '||chr(10)||
'    '||chr(10)||
'    end if;'||
' '||chr(10)||
'    '||chr(10)||
'    '||chr(10)||
'end;'||chr(10)||
' '||chr(10)||
''||chr(10)||
''||chr(10)||
'function advanced_radio_ajax(p_item   in apex_plugin.t_page_item,'||chr(10)||
'                          p_plugin in apex_plugin.t_plugin )'||chr(10)||
'    return apex_plugin.t_page_item_ajax_result'||chr(10)||
''||chr(10)||
'as'||chr(10)||
'l_ret apex_plugin.t_page_item_ajax_result;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'apex_plugin_util.print_lov_as_json(p_item.lov_definition,'||chr(10)||
'                                  p_item.name,'||chr(10)||
'                                  true);'||chr(10)||
'retur'||
'n l_ret;'||chr(10)||
'end;'||chr(10)||
''||chr(10)||
''||chr(10)||
'function  render_advanced_radio ('||chr(10)||
'    p_item                in apex_plugin.t_page_item,'||chr(10)||
'    p_plugin              in apex_plugin.t_plugin,'||chr(10)||
'    p_value               in varchar2,'||chr(10)||
'    p_is_readonly         in boolean,'||chr(10)||
'    p_is_printer_friendly in boolean )'||chr(10)||
'    return apex_plugin.t_page_item_render_result'||chr(10)||
' '||chr(10)||
'is'||chr(10)||
''||chr(10)||
''||chr(10)||
'l_result apex_plugin.t_page_item_render_result;'||chr(10)||
' '||chr(10)||
'c_title_param apex_appl'||
'ication_page_items.attribute_01%type:=nvl(p_item.attribute_01, ''Select one or more items'');'||chr(10)||
'c_style apex_application_page_items.attribute_02%type:=p_item.attribute_02;'||chr(10)||
''||chr(10)||
'begin '||chr(10)||
''||chr(10)||
''||chr(10)||
'if apex_application.g_debug then'||chr(10)||
'apex_plugin_util.debug_page_item( p_plugin, p_item, p_value, p_is_readonly, p_is_printer_friendly);'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'apex_javascript.add_onload_code ('||chr(10)||
'    '||chr(10)||
'    p_code => '''||chr(10)||
'       oldsub = apex.subm'||
'it ; '||chr(10)||
'       apex.submit = function() {'||chr(10)||
'       $(''''.advanced_radio_other_text_input'''').prop(''''disabled'''', ''''disabled'''');'||chr(10)||
'       oldsub ();'||chr(10)||
'       } '',  -- the key means it can only be added once on a page '||chr(10)||
'       p_key => ''advanced_radio_other_text_input_init'' /* ||p_item.name */'||chr(10)||
'    '||chr(10)||
');'||chr(10)||
'                  '||chr(10)||
'          '||chr(10)||
''||chr(10)||
''||chr(10)||
'htp.p(''<fieldset class="radio_group''||p_item.element_attributes||'' name="''||ape'||
'x_plugin.GET_INPUT_NAME_FOR_PAGE_ITEM(true)||'||chr(10)||
'''" id="''||p_item.name||''"  title="''||c_title_param||''"><table style="border-spacing:0; "> '');    '||chr(10)||
' '||chr(10)||
' render_options(p_item, p_value , p_is_readonly );'||chr(10)||
'htp.p(''</table></fieldset>'');'||chr(10)||
'return l_result;'||chr(10)||
'END;'||chr(10)||
''
 ,p_render_function => 'render_advanced_radio'
 ,p_ajax_function => 'advanced_radio_ajax'
 ,p_standard_attributes => 'VISIBLE:READONLY:SOURCE:ELEMENT:WIDTH:ELEMENT_OPTION:ENCRYPT:LOV:LOV_DISPLAY_NULL'
 ,p_sql_min_column_count => 2
 ,p_sql_max_column_count => 2
 ,p_help_text => '<div>'||chr(10)||
'	element_max_length:max characters allowed in other text field&nbsp;</div>'||chr(10)||
'<div>'||chr(10)||
'	&nbsp;</div>'||chr(10)||
'<div>'||chr(10)||
'	lov_display_extra: after saving, any value entered into Other is displayed as an extra selected radio option. If this option is enabled, other will never be selected after saving.&nbsp;</div>'||chr(10)||
'<div>'||chr(10)||
'	&nbsp;</div>'||chr(10)||
'<div>'||chr(10)||
'	lov_display_null: if selected, displays this option before &quot;Other&quot;</div>'||chr(10)||
''
 ,p_version_identifier => '1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 10349015248035023 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Number of Columns'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_default_value => '1'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 10349519404036231 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Sort By'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => false
 ,p_default_value => 'Columns'
 ,p_is_translatable => false
 ,p_help_text => 'When you have more than one radio column, you can sort your options by row or column, apex radio groups only sort by rows.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 10350022867037177 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 10349519404036231 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Rows'
 ,p_return_value => 'Rows'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 10350525637037956 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 10349519404036231 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Columns'
 ,p_return_value => 'Columns'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 10351303605041066 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Enable Other Option'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'Y'
 ,p_is_translatable => false
 ,p_help_text => 'Set this to No, if you want this radio group to appear like a normal apex radio group and disable the "Other" option and its text box.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 10351812955043825 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Other display text'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Other'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 10351303605041066 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Change the value of "Other" to something else. ie. "Other, please specify." or leave it blank, and the option will just show the text input box without a label.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 10352319881045819 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Other return value'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Other'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 10351303605041066 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'This is the value returned when The Other option is selected, but no value entered into the text box.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 10352828885048338 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Start other option on new line'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'N'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 10351303605041066 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Force "Other" option with text box onto its own line at the end of the radio group. '
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 10353307199051536 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Allow final options to span columns'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'Y'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 10349015248035023 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_IN_LIST'
 ,p_depending_on_expression => '0,1'
 ,p_help_text => 'If the number of Options does not fit neatly into the number of columns, the last row will have less options, this allows the last option to fill remaining columns. This is useful if there is one display value that has more characters than others. '||chr(10)||
'Also applies to the "Other" option, and may apply to the last two rows if the "Other" option is set display on a new line.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 10353819666055226 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 10348705205032043 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Placeholder text'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Please specify ...'
 ,p_is_translatable => false
 ,p_help_text => 'Because "Placeholder" is not a standard attribute in apex 4.'
  );
null;
 
end;
/

commit;
begin 
execute immediate 'begin dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
prompt  ...done
