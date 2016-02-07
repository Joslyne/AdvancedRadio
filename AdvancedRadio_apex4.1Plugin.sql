set define off
set verify off
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
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040100 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,1044410528210932));
 
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
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2011.02.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,122);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/advanced_radio
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 482691628042038047 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'AU.JC.ADVANCED_RADIO'
 ,p_display_name => 'Advanced Radio Group'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'--attribute_01 = num columns '||unistr('\000a')||
'--attribute_02 = sort by (rows,columns)'||unistr('\000a')||
'--attribute_03 = other Y/N'||unistr('\000a')||
'--attribute_04 = Other - display label  default ''Other'' '||unistr('\000a')||
'--attribute_05 = Other - return value default ''Other'' '||unistr('\000a')||
'--attribute_06 = other on own line default false.  '||unistr('\000a')||
'--attribute_07 = Allow final options to span columns'||unistr('\000a')||
'--attribute_08 = placeholder value in apex 4'||unistr('\000a')||
''||unistr('\000a')||
'procedure start_option( l_total in numbe'||
'r  , p_item in apex_plugin.t_page_item , actual_total in number  ) is '||unistr('\000a')||
''||unistr('\000a')||
'num_cols number  :=   0; '||unistr('\000a')||
'startcell boolean  := true; '||unistr('\000a')||
'begin '||unistr('\000a')||
''||unistr('\000a')||
'    num_cols := p_item.attribute_01; '||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'    if apex_application.g_debug then '||unistr('\000a')||
'      --wwv_flow.debug( ''START OPTION: total options   = ''||actual_total ||'' this option   = ''||l_total); '||unistr('\000a')||
'      if p_item.attribute_02 = ''Rows'' then'||unistr('\000a')||
'                wwv_flow.debug (''STAR'||
'T OPTION: this option = ''||l_total ||'', start new row on zero = '' || (mod( l_total ,  num_cols)  ) );'||unistr('\000a')||
'      else '||unistr('\000a')||
'                wwv_flow.debug (''START OPTION: this option = ''||l_total ||'', start new row on zero = '' || mod( l_total , ceil( actual_total  / num_cols ) )) ;'||unistr('\000a')||
'      end if  ;'||unistr('\000a')||
'    end if; '||unistr('\000a')||
''||unistr('\000a')||
'                   '||unistr('\000a')||
'     if actual_total = l_total then'||unistr('\000a')||
'        null ; '||unistr('\000a')||
'     '||unistr('\000a')||
'     elsif p_item.a'||
'ttribute_06  = ''Y'' and actual_total -1 = l_total  then '||unistr('\000a')||
'       htp.p(''<tr><td style="vertical-align:top;" colspan="''||p_item.attribute_01||''">''); '||unistr('\000a')||
'       wwv_flow.debug(''extra colspan'') ; '||unistr('\000a')||
'       '||unistr('\000a')||
'     else '||unistr('\000a')||
''||unistr('\000a')||
'       if p_item.attribute_02 = ''Rows''  then '||unistr('\000a')||
'         if  mod( l_total  ,  num_cols  ) = 0 then -- start new row '||unistr('\000a')||
'            htp.p('' <tr>''); '||unistr('\000a')||
'         else -- start new column '||unistr('\000a')||
'            '||
'null; '||unistr('\000a')||
'         end if; '||unistr('\000a')||
'       else  -- sort by columns '||unistr('\000a')||
'         if  mod( l_total ,  ceil( actual_total  / num_cols) )  = 0    then -- start new column  '||unistr('\000a')||
'            null ; '||unistr('\000a')||
'         else -- continue current colunm '||unistr('\000a')||
'             startcell := false ; '||unistr('\000a')||
'         end if; '||unistr('\000a')||
'       end if ; '||unistr('\000a')||
'       '||unistr('\000a')||
'       if startcell then '||unistr('\000a')||
'         htp.p('' <td''||case '||unistr('\000a')||
'                      when ( actual_total -1 = l_'||
'total and p_item.attribute_07 =''Y''  ) '||unistr('\000a')||
'                      or ( actual_total - 2  = l_total and p_item.attribute_03 =''Y'' and p_item.attribute_07 =''Y'' and p_item.attribute_06 =''Y''  ) '||unistr('\000a')||
'                       then '' colspan="''|| p_item.attribute_01  ||''"''  end ||''   style="vertical-align:top;"  >''  ); '||unistr('\000a')||
'       end if; '||unistr('\000a')||
'       '||unistr('\000a')||
'     end if; '||unistr('\000a')||
'    '||unistr('\000a')||
'end ; '||unistr('\000a')||
''||unistr('\000a')||
'procedure end_option( l_total in number  , p_i'||
'tem in apex_plugin.t_page_item , actual_total in number  ) is '||unistr('\000a')||
'l_column_value_list   apex_plugin_util.t_column_value_list; '||unistr('\000a')||
'--actual_total number := 0; '||unistr('\000a')||
'num_cols number  :=   0; '||unistr('\000a')||
'startcell boolean  := true; '||unistr('\000a')||
'begin '||unistr('\000a')||
'    l_column_value_list :='||unistr('\000a')||
'            apex_plugin_util.get_data ('||unistr('\000a')||
'                p_sql_statement    => p_item.lov_definition,'||unistr('\000a')||
'                p_min_columns      => 2,'||unistr('\000a')||
'                '||
'p_max_columns      => 2,'||unistr('\000a')||
'                p_component_name   => p_item.name);'||unistr('\000a')||
''||unistr('\000a')||
'    num_cols := p_item.attribute_01; '||unistr('\000a')||
''||unistr('\000a')||
'    if apex_application.g_debug then /*'||unistr('\000a')||
'        wwv_flow.debug( ''END OPTION: total options   = ''||actual_total || '' this option   = ''||l_total  ); '||unistr('\000a')||
'      if p_item.attribute_02 = ''Rows'' then'||unistr('\000a')||
'                wwv_flow.debug ('' start new row on zero = '' || (mod( l_total ,  num_cols)  )'||
' );'||unistr('\000a')||
'      else '||unistr('\000a')||
'                 wwv_flow.debug ('' start new row on zero  = '' || mod( l_total ,  ceil( actual_total  / num_cols ) ) ) ;'||unistr('\000a')||
'      end if  ;*/'||unistr('\000a')||
'      '||unistr('\000a')||
'      if p_item.attribute_02 = ''Rows'' then'||unistr('\000a')||
'                wwv_flow.debug (''END OPTION  : this option = ''||l_total ||'', start new row on zero = '' || (mod( l_total ,  num_cols)  ) );'||unistr('\000a')||
'      else '||unistr('\000a')||
'                wwv_flow.debug (''END OPTION: '||
'this option = ''||l_total ||'', start new row on zero = '' || mod( l_total , ceil( actual_total  / num_cols ) )) ;'||unistr('\000a')||
'      end if  ;'||unistr('\000a')||
'    end if; '||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'     if actual_total = l_total then'||unistr('\000a')||
'        htp.p(''</td></tr>''); '||unistr('\000a')||
'     '||unistr('\000a')||
'     elsif p_item.attribute_06  = ''Y'' and actual_total -1 = l_total  then '||unistr('\000a')||
'       htp.p(''</td></tr>''); '||unistr('\000a')||
'      '||unistr('\000a')||
'     else '||unistr('\000a')||
''||unistr('\000a')||
'       if p_item.attribute_02 = ''Rows''  then '||unistr('\000a')||
'         if  mod'||
'( l_total  ,  num_cols  ) = 0 then -- start new row '||unistr('\000a')||
'            htp.p(''</td></tr>'');'||unistr('\000a')||
'         else -- start new column '||unistr('\000a')||
'            htp.p(''</td>'');'||unistr('\000a')||
'         end if; '||unistr('\000a')||
'       else  -- sort by columns '||unistr('\000a')||
'         if  mod( l_total ,  ceil( actual_total  / num_cols) )  = 0    then -- start new column  '||unistr('\000a')||
'            htp.p(''</td>''); '||unistr('\000a')||
'         else -- continue current colunm '||unistr('\000a')||
'             startcell := false'||
' ; '||unistr('\000a')||
'         end if; '||unistr('\000a')||
'       end if ; '||unistr('\000a')||
'     end if; '||unistr('\000a')||
'    '||unistr('\000a')||
'end ; '||unistr('\000a')||
''||unistr('\000a')||
'procedure render_options( p_item  in apex_plugin.t_page_item,  p_value  in varchar2 , p_is_readonly in boolean ) '||unistr('\000a')||
'is'||unistr('\000a')||
'l_column_value_list   apex_plugin_util.t_column_value_list;'||unistr('\000a')||
'l_selected boolean := false; '||unistr('\000a')||
'  l_name          varchar2(30)    := apex_plugin.get_input_name_for_page_item(false);'||unistr('\000a')||
'  l_total number := 0; '||unistr('\000a')||
'  actual_total nu'||
'mber := 0;  '||unistr('\000a')||
'  render_extra boolean := false;   '||unistr('\000a')||
'  render_null  boolean := false;   '||unistr('\000a')||
'  render_other boolean := false; '||unistr('\000a')||
'  selected_value varchar2(1) ; '||unistr('\000a')||
'  placeholder_value varchar2(2000) ; '||unistr('\000a')||
'begin'||unistr('\000a')||
''||unistr('\000a')||
'  '||unistr('\000a')||
'  -- set the placeholder '||unistr('\000a')||
'  placeholder_value := p_item.attribute_08; '||unistr('\000a')||
'  -- try to retrieve attribute_08'||unistr('\000a')||
'  /*'||unistr('\000a')||
'  begin '||unistr('\000a')||
'   execute immediate '' '||unistr('\000a')||
'     declare '||unistr('\000a')||
'       ii apex_plugin.t_page_item; '||unistr('\000a')||
'     beg'||
'in '||unistr('\000a')||
'       ii := :b1 ; '||unistr('\000a')||
'       :b2 := ii.attribute_08; '||unistr('\000a')||
'     end; '||unistr('\000a')||
'   '' using in p_item , out placeholder_value ;'||unistr('\000a')||
'   exception when others then null; '||unistr('\000a')||
'   end; '||unistr('\000a')||
'   '||unistr('\000a')||
'  -- try to retrieve placeholder  attribute '||unistr('\000a')||
'  begin '||unistr('\000a')||
'   execute immediate '' '||unistr('\000a')||
'     declare '||unistr('\000a')||
'       ii apex_plugin.t_page_item; '||unistr('\000a')||
'     begin '||unistr('\000a')||
'       ii := :b1 ; '||unistr('\000a')||
'       :b2 := ii.placeholder; '||unistr('\000a')||
'     end; '||unistr('\000a')||
'   '' using in p_item , out placeho'||
'lder_value ;'||unistr('\000a')||
'   exception when others then null; '||unistr('\000a')||
'   end; '||unistr('\000a')||
'*/ '||unistr('\000a')||
'  '||unistr('\000a')||
''||unistr('\000a')||
'  l_column_value_list :='||unistr('\000a')||
'        apex_plugin_util.get_data ('||unistr('\000a')||
'            p_sql_statement    => p_item.lov_definition,'||unistr('\000a')||
'            p_min_columns      => 2,'||unistr('\000a')||
'            p_max_columns      => 2,'||unistr('\000a')||
'            p_component_name   => p_item.name);'||unistr('\000a')||
' '||unistr('\000a')||
''||unistr('\000a')||
'    actual_total := l_column_value_list(1).count ; '||unistr('\000a')||
'    '||unistr('\000a')||
'    /* decide which Options to re'||
'nder and now many there will be */ '||unistr('\000a')||
'    '||unistr('\000a')||
'    -- is the current value in the lov. '||unistr('\000a')||
'    for i in 1 .. l_column_value_list(1).count'||unistr('\000a')||
'    loop'||unistr('\000a')||
'      if  p_value = l_column_value_list(2)(i) then '||unistr('\000a')||
'         l_selected := true;  -- found it '||unistr('\000a')||
'        wwv_flow.debug( '' item value found in lov.'');'||unistr('\000a')||
'      else '||unistr('\000a')||
'         wwv_flow.debug( '' item value not found in lov.'');'||unistr('\000a')||
'      end if; '||unistr('\000a')||
'    end loop; '||unistr('\000a')||
'  '||unistr('\000a')||
'    -- "O'||
'ther" option '||unistr('\000a')||
'    if p_item.attribute_03 = ''Y''  then '||unistr('\000a')||
'      actual_total :=  actual_total+1; '||unistr('\000a')||
'      render_other:= true; '||unistr('\000a')||
'      '||unistr('\000a')||
'      if  p_value =  nvl(p_item.attribute_05 , ''Other'' )'||unistr('\000a')||
'      then '||unistr('\000a')||
'         l_selected := true; -- found it '||unistr('\000a')||
'         selected_value := ''O'' ;'||unistr('\000a')||
'      end if;       '||unistr('\000a')||
'    end if; '||unistr('\000a')||
''||unistr('\000a')||
'    -- Null option '||unistr('\000a')||
'    if p_item.lov_display_null   then '||unistr('\000a')||
'      actual_total :=  actual_tot'||
'al+1; '||unistr('\000a')||
'      render_null := true; '||unistr('\000a')||
'      '||unistr('\000a')||
'      if p_item.lov_null_value = p_value'||unistr('\000a')||
'      or ( p_value is null and p_item.lov_null_value is null )'||unistr('\000a')||
'      then '||unistr('\000a')||
'        l_selected := true;  -- found it '||unistr('\000a')||
'         selected_value := ''N'' ;'||unistr('\000a')||
'       end if;'||unistr('\000a')||
'    end if; '||unistr('\000a')||
'    '||unistr('\000a')||
'    -- extra value is enabled '||unistr('\000a')||
'    if p_item.lov_display_extra '||unistr('\000a')||
'    -- and  did not find a value in the LOV '||unistr('\000a')||
'    and not l_selected '||unistr('\000a')||
' '||
'   then '||unistr('\000a')||
'      render_extra := true; '||unistr('\000a')||
'      actual_total := actual_total + 1 ;'||unistr('\000a')||
'         selected_value := ''E'' ;'||unistr('\000a')||
'    end if; '||unistr('\000a')||
'    '||unistr('\000a')||
'    -- "Other" option '||unistr('\000a')||
'    -- as a catchall when display extra is disabled and other is enabled '||unistr('\000a')||
'    if render_other '||unistr('\000a')||
'    and not p_item.lov_display_extra   '||unistr('\000a')||
'    and p_value is not null '||unistr('\000a')||
'    then       '||unistr('\000a')||
'         l_selected := true; -- found it '||unistr('\000a')||
'         selected_value :'||
'= ''O'' ;      '||unistr('\000a')||
'    end if; '||unistr('\000a')||
'   '||unistr('\000a')||
'    '||unistr('\000a')||
'    if apex_application.g_debug then '||unistr('\000a')||
'      wwv_flow.debug('||unistr('\000a')||
'          '' render_other = ''||case when render_other then ''Y'' else ''N'' end ||'||unistr('\000a')||
'          '', render_extra = ''||case when render_extra then ''Y'' else ''N'' end ||'||unistr('\000a')||
'          '', render_null  = ''||case when render_null then ''Y'' else ''N'' end ||'||unistr('\000a')||
'          '', actual_total = ''||actual_total'||unistr('\000a')||
'      ); '||unistr('\000a')||
'    end if ; '||unistr('\000a')||
' '||
'   '||unistr('\000a')||
'    /**** Start rendering *****/ '||unistr('\000a')||
'    '||unistr('\000a')||
'    htp.p(''<tr><td>'');'||unistr('\000a')||
' '||unistr('\000a')||
' for i in 1 .. l_column_value_list(1).count'||unistr('\000a')||
'    loop'||unistr('\000a')||
'      if i > 1 then '||unistr('\000a')||
'       start_option( l_total , p_item, actual_total  ) ; '||unistr('\000a')||
'      end if; '||unistr('\000a')||
'    '||unistr('\000a')||
'        if apex_application.g_debug then'||unistr('\000a')||
'            wwv_flow.debug( l_column_value_list(1)(i)||'',''||l_column_value_list(2)(i));'||unistr('\000a')||
'        end if; '||unistr('\000a')||
'        '||unistr('\000a')||
'      if  p_value = l_col'||
'umn_value_list(2)(i) then '||unistr('\000a')||
'         l_selected := true; '||unistr('\000a')||
'      end if; '||unistr('\000a')||
'    '||unistr('\000a')||
'        sys.htp.p(''<div style="whitespace:no-wrap;" > ''||'||unistr('\000a')||
'            ''<input type="radio"  style="margin:5px 3px 5px 5px; "  name="''||l_name||''"  ''||'||unistr('\000a')||
'                   '' id="''||p_item.name||''_''||(i-1)||''" ''||'||unistr('\000a')||
'                    case when p_is_readonly then '' readonly="readonly" '' end ||  '||unistr('\000a')||
'                     ''value="'''||
'||'||unistr('\000a')||
'                           sys.htf.escape_sc(l_column_value_list(2)(i))||''"''|| -- value column'||unistr('\000a')||
'                     case when p_value = l_column_value_list(2)(i) then  '' checked="checked" '' end || '||unistr('\000a')||
'                    '' ''||p_item.element_option_attributes||'' ''||'||unistr('\000a')||
'            ''>''||'||unistr('\000a')||
'            ''<label for="''||p_item.name||''_''||(i-1)||''">''||sys.htf.escape_sc(l_column_value_list(1)(i))||''</label> '''||
' ||-- display column '||unistr('\000a')||
'            ''</div>'''||unistr('\000a')||
'            );'||unistr('\000a')||
'            '||unistr('\000a')||
'       l_total := i; '||unistr('\000a')||
'       end_option( l_total , p_item, actual_total  ) ; '||unistr('\000a')||
'       '||unistr('\000a')||
'    end loop;'||unistr('\000a')||
'    '||unistr('\000a')||
'    '||unistr('\000a')||
'    l_total := l_column_value_list(1).count ; '||unistr('\000a')||
''||unistr('\000a')||
'    if render_extra then '||unistr('\000a')||
''||unistr('\000a')||
'      start_option( l_total , p_item, actual_total  ) ; '||unistr('\000a')||
'      '||unistr('\000a')||
'        sys.htp.p(''<div style="whitespace:no-wrap;" > ''||'||unistr('\000a')||
'        ''<input type="'||
'radio"    style="margin:5px 3px 5px 5px; "     name="''||l_name||''"  ''|| '||unistr('\000a')||
'                ''id="''||p_item.name||''_''||l_total ||''" ''||'||unistr('\000a')||
'                case when p_is_readonly then '' readonly="readonly" '' end || '||unistr('\000a')||
'        '' value=''||sys.htf.escape_sc(p_value)|| ''" checked="checked" ''    || '' />''||'||unistr('\000a')||
'        ''<label for="''||p_item.name||''_''||l_total  ||''">''|| nvl(sys.htf.escape_sc(p_value), ''(null)'') ||''<'||
'/label> ''||'||unistr('\000a')||
'       ''</div>'''||unistr('\000a')||
'        ); '||unistr('\000a')||
'      l_total := l_total + 1; '||unistr('\000a')||
'      end_option( l_total , p_item , actual_total  ) ; '||unistr('\000a')||
'    end if; '||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'    --if p_item.lov_display_null  then'||unistr('\000a')||
'    if render_null then '||unistr('\000a')||
'    start_option( l_total , p_item, actual_total  ) ;  '||unistr('\000a')||
'      '||unistr('\000a')||
'        sys.htp.p(''<div style="whitespace:no-wrap;" > ''||'||unistr('\000a')||
'        ''<input type="radio"    style="margin:5px 3px 5px 5px; "   name='||
'"''||l_name||''"  id="''||p_item.name||''_''||l_total ||''" ''||'||unistr('\000a')||
'          case when p_is_readonly then '' readonly="readonly" '' end || '||unistr('\000a')||
'        '' value="''||nvl( sys.htf.escape_sc(p_item.lov_null_value), '''')|| ''" ''||'||unistr('\000a')||
'          case '||unistr('\000a')||
'              --when p_item.lov_null_value = p_value '||unistr('\000a')||
'              --or ( p_value is null and p_item.lov_null_value is null ) '||unistr('\000a')||
'              when selected_value = ''N''     '||unistr('\000a')||
'  '||
'            then   '' checked="checked" '' '||unistr('\000a')||
'              end    || '||unistr('\000a')||
'            '' />''||'||unistr('\000a')||
'        ''<label for="''||p_item.name||''_''||l_total  ||''">''|| nvl( sys.htf.escape_sc(p_item.lov_null_text), ''Null'')  ||''</label> ''||'||unistr('\000a')||
'       ''</div>'''||unistr('\000a')||
'        ); '||unistr('\000a')||
''||unistr('\000a')||
'      l_total := l_total + 1; '||unistr('\000a')||
'      end_option( l_total , p_item, actual_total  ) ; '||unistr('\000a')||
'      '||unistr('\000a')||
'    end if; '||unistr('\000a')||
''||unistr('\000a')||
'   if render_other then '||unistr('\000a')||
''||unistr('\000a')||
'     start_option( l'||
'_total , p_item, actual_total  ) ;  '||unistr('\000a')||
'    '||unistr('\000a')||
'    sys.htp.p(''<div style="whitespace:no-wrap;" > ''||'||unistr('\000a')||
'        ''<input type="radio"   style="margin:5px 3px 5px 5px; "   name="''||l_name||''"  ''||'||unistr('\000a')||
'                 case when p_is_readonly then '' readonly="readonly" '' end || '||unistr('\000a')||
'                 '' id="''||p_item.name||''_''||l_total  ||''" ''||'||unistr('\000a')||
'               '' value''|| case '||unistr('\000a')||
'                              --when not '||
'l_selected and p_value is not null '||unistr('\000a')||
'                              when selected_value = ''O'' '||unistr('\000a')||
'                              then ''="''||sys.htf.escape_sc(p_value) || ''" checked="checked" '' '||unistr('\000a')||
'                              else ''="''||p_item.attribute_05|| ''" ''  -- default value for "Other" option. '||unistr('\000a')||
'                          end   ||'||unistr('\000a')||
'         '' />''||'||unistr('\000a')||
'        ''<label for="''||p_item.name||''_''||l_total ||'''||
'">''||p_item.attribute_04||''</label> '''||unistr('\000a')||
'        ); '||unistr('\000a')||
'        sys.htp.p('||unistr('\000a')||
'          ''<input onChange=" var v = $(this).val(); var n = $(''''#''||p_item.name||''_''||l_total ||'''''');  n.val( v ) ;  "  ''||'||unistr('\000a')||
'                ''  onKeyup=" var v = $(this).val(); var n = $(''''#''||p_item.name||''_''||l_total ||''''''); if (v.length > 0 ) n.prop(''''checked'''', true);  n.val( v ) ;  " ''||'||unistr('\000a')||
'                   ''value="''|| case wh'||
'en /*not l_selected */ selected_value = ''O'' then  sys.htf.escape_sc(p_value)  end ||''" ''||'||unistr('\000a')||
'                    '' class="advanced_radio_other_text_input" size="''||p_item.element_width||''"  maxlength="''||p_item.element_max_length||''" ''||'||unistr('\000a')||
'                     case when p_is_readonly then '' readonly="readonly" '' end || '||unistr('\000a')||
'                    ''placeholder="''|| placeholder_value  ||''"''||'||unistr('\000a')||
'             ''></'||
'input></div>'''||unistr('\000a')||
'    );-- display column '||unistr('\000a')||
'    '||unistr('\000a')||
'      l_total := l_total + 1; '||unistr('\000a')||
'    end_option( l_total , p_item, actual_total ) ;  '||unistr('\000a')||
'    '||unistr('\000a')||
'    end if; '||unistr('\000a')||
'    '||unistr('\000a')||
'    '||unistr('\000a')||
'end;'||unistr('\000a')||
' '||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function advanced_radio_ajax(p_item   in apex_plugin.t_page_item,'||unistr('\000a')||
'                          p_plugin in apex_plugin.t_plugin )'||unistr('\000a')||
'    return apex_plugin.t_page_item_ajax_result'||unistr('\000a')||
''||unistr('\000a')||
'as'||unistr('\000a')||
'l_ret apex_plugin.t_page_item_ajax_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
''||unistr('\000a')||
'apex_pl'||
'ugin_util.print_lov_as_json(p_item.lov_definition,'||unistr('\000a')||
'                                  p_item.name,'||unistr('\000a')||
'                                  true);'||unistr('\000a')||
'return l_ret;'||unistr('\000a')||
'end;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function  render_advanced_radio ('||unistr('\000a')||
'    p_item                in apex_plugin.t_page_item,'||unistr('\000a')||
'    p_plugin              in apex_plugin.t_plugin,'||unistr('\000a')||
'    p_value               in varchar2,'||unistr('\000a')||
'    p_is_readonly         in boolean,'||unistr('\000a')||
'    p_is_printer_friendl'||
'y in boolean )'||unistr('\000a')||
'    return apex_plugin.t_page_item_render_result'||unistr('\000a')||
' '||unistr('\000a')||
'is'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'l_result apex_plugin.t_page_item_render_result;'||unistr('\000a')||
' '||unistr('\000a')||
'c_title_param apex_application_page_items.attribute_01%type:=nvl(p_item.attribute_01, ''Select one or more items'');'||unistr('\000a')||
'c_style apex_application_page_items.attribute_02%type:=p_item.attribute_02;'||unistr('\000a')||
''||unistr('\000a')||
'begin '||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'if apex_application.g_debug then'||unistr('\000a')||
'apex_plugin_util.debug_page_item( p_plugin, p'||
'_item, p_value, p_is_readonly, p_is_printer_friendly);'||unistr('\000a')||
'end if;'||unistr('\000a')||
''||unistr('\000a')||
'apex_javascript.add_onload_code ('||unistr('\000a')||
'    '||unistr('\000a')||
'    p_code => '''||unistr('\000a')||
'       oldsub = apex.submit ; '||unistr('\000a')||
'       apex.submit = function() {'||unistr('\000a')||
'       $(''''.advanced_radio_other_text_input'''').prop(''''disabled'''', ''''disabled'''');'||unistr('\000a')||
'       oldsub ();'||unistr('\000a')||
'       } '',  -- the key means it can only be added once on a page '||unistr('\000a')||
'       p_key => ''advanced_radio_other_text_input_i'||
'nit'' /* ||p_item.name */'||unistr('\000a')||
'    '||unistr('\000a')||
');'||unistr('\000a')||
'                  '||unistr('\000a')||
'          '||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'htp.p(''<fieldset class="radio_group''||p_item.element_attributes||'' name="''||apex_plugin.GET_INPUT_NAME_FOR_PAGE_ITEM(true)||'||unistr('\000a')||
'''" id="''||p_item.name||''"  title="''||c_title_param||''"><table style="border-spacing:0; "> '');    '||unistr('\000a')||
' '||unistr('\000a')||
' render_options(p_item, p_value , p_is_readonly );'||unistr('\000a')||
'htp.p(''</table></fieldset>'');'||unistr('\000a')||
'return l_result;'||unistr('\000a')||
'END;'||unistr('\000a')||
''||unistr('\000a')||
''
 ,p_render_function => 'render_advanced_radio'
 ,p_ajax_function => 'advanced_radio_ajax'
 ,p_standard_attributes => 'VISIBLE:READONLY:SOURCE:ELEMENT:WIDTH:ELEMENT_OPTION:ENCRYPT:LOV:LOV_DISPLAY_NULL:CASCADING_LOV'
 ,p_sql_min_column_count => 2
 ,p_sql_max_column_count => 2
 ,p_substitute_attributes => true
 ,p_help_text => '<div>'||unistr('\000a')||
'	element_max_length:max characters allowed in other text field&nbsp;</div>'||unistr('\000a')||
'<div>'||unistr('\000a')||
'	&nbsp;</div>'||unistr('\000a')||
'<div>'||unistr('\000a')||
'	lov_display_extra: after saving, any value entered into Other is displayed as an extra selected radio option. If this option is enabled, other will never be selected after saving.&nbsp;</div>'||unistr('\000a')||
'<div>'||unistr('\000a')||
'	&nbsp;</div>'||unistr('\000a')||
'<div>'||unistr('\000a')||
'	lov_display_null: if selected, displays this option before &quot;Other&quot;</div>'||unistr('\000a')||
''
 ,p_version_identifier => '1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 482699707049041436 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 482691628042038047 + wwv_flow_api.g_id_offset
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
  p_id => 482704112936043129 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 482691628042038047 + wwv_flow_api.g_id_offset
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
  p_id => 482708514667043592 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 482704112936043129 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Rows'
 ,p_return_value => 'Rows'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 482712816745044222 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 482704112936043129 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Columns'
 ,p_return_value => 'Columns'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 482733211335052130 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 482691628042038047 + wwv_flow_api.g_id_offset
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
  p_id => 482737626226056425 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 482691628042038047 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Other display text'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Other'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 482733211335052130 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Change the value of "Other" to something else. ie. "Other, please specify." or leave it blank, and the option will just show the text input box without a label.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 483198419039266372 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 482691628042038047 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Other return value'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Other'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 482733211335052130 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'This is the value returned when The Other option is selected, but no value entered into the text box.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 483166310596254392 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 482691628042038047 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Start other option on new line'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'N'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 482733211335052130 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Force "Other" option with text box onto its own line at the end of the radio group. '
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 483137901461242294 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 482691628042038047 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Allow final options to span columns'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'Y'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 482699707049041436 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_IN_LIST'
 ,p_depending_on_expression => '0,1'
 ,p_help_text => 'If the number of Options does not fit neatly into the number of columns, the last row will have less options, this allows the last option to fill remaining columns. This is useful if there is one display value that has more characters than others. '||unistr('\000a')||
'Also applies to the "Other" option, and may apply to the last two rows if the "Other" option is set display on a new line.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 483113405486234009 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 482691628042038047 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Placeholder text'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Please specify ...'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 482733211335052130 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
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
