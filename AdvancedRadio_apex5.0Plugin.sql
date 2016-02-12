set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.1.00.06'
,p_default_workspace_id=>1065201659198993
,p_default_application_id=>101
,p_default_owner=>'SC_GEN'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/au_jp_advanced_radio
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(24522654590973709232)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'AU.JP.ADVANCED_RADIO'
,p_display_name=>'Advanced Radio'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'--attribute_01 = num columns ',
'--attribute_02 = sort by (rows,columns)',
'--attribute_03 = other Y/N',
'--attribute_04 = Other - display label  default ''Other'' ',
'--attribute_05 = Other - return value default ''Other'' ',
'--attribute_06 = other on own line default false.  ',
'--attribute_07 = Allow final options to span columns',
'--attribute_08 = placeholder value in apex 4',
'',
'procedure start_option( l_total in number  , p_item in apex_plugin.t_page_item , actual_total in number  ) is ',
'',
'num_cols number  :=   0; ',
'startcell boolean  := true; ',
'begin ',
'',
'    num_cols := p_item.attribute_01; ',
'',
'',
'    if apex_application.g_debug then ',
'      --wwv_flow.debug( ''START OPTION: total options   = ''||actual_total ||'' this option   = ''||l_total); ',
'      if p_item.attribute_02 = ''Rows'' then',
'                wwv_flow.debug (''START OPTION: this option = ''||l_total ||'', start new row on zero = '' || (mod( l_total ,  num_cols)  ) );',
'      else ',
'                wwv_flow.debug (''START OPTION: this option = ''||l_total ||'', start new row on zero = '' || mod( l_total , ceil( actual_total  / num_cols ) )) ;',
'      end if  ;',
'    end if; ',
'',
'                   ',
'     if actual_total = l_total then',
'        null ; ',
'     ',
'     elsif p_item.attribute_06  = ''Y'' and actual_total -1 = l_total  then ',
'       htp.p(''<tr><td style="vertical-align:top;" colspan="''||p_item.attribute_01||''">''); ',
'       wwv_flow.debug(''extra colspan'') ; ',
'       ',
'     else ',
'',
'       if p_item.attribute_02 = ''Rows''  then ',
'         if  mod( l_total  ,  num_cols  ) = 0 then -- start new row ',
'            htp.p('' <tr>''); ',
'         else -- start new column ',
'            null; ',
'         end if; ',
'       else  -- sort by columns ',
'         if  mod( l_total ,  ceil( actual_total  / num_cols) )  = 0    then -- start new column  ',
'            null ; ',
'         else -- continue current colunm ',
'             startcell := false ; ',
'         end if; ',
'       end if ; ',
'       ',
'       if startcell then ',
'         htp.p('' <td''||case ',
'                      when ( actual_total -1 = l_total and p_item.attribute_07 =''Y''  ) ',
'                      or ( actual_total - 2  = l_total and p_item.attribute_03 =''Y'' and p_item.attribute_07 =''Y'' and p_item.attribute_06 =''Y''  ) ',
'                       then '' colspan="''|| p_item.attribute_01  ||''"''  end ||''   style="vertical-align:top;"  >''  ); ',
'       end if; ',
'       ',
'     end if; ',
'    ',
'end ; ',
'',
'procedure end_option( l_total in number  , p_item in apex_plugin.t_page_item , actual_total in number  ) is ',
'l_column_value_list   apex_plugin_util.t_column_value_list; ',
'--actual_total number := 0; ',
'num_cols number  :=   0; ',
'startcell boolean  := true; ',
'begin ',
'    l_column_value_list :=',
'            apex_plugin_util.get_data (',
'                p_sql_statement    => p_item.lov_definition,',
'                p_min_columns      => 2,',
'                p_max_columns      => 2,',
'                p_component_name   => p_item.name);',
'',
'    num_cols := p_item.attribute_01; ',
'',
'    if apex_application.g_debug then /*',
'        wwv_flow.debug( ''END OPTION: total options   = ''||actual_total || '' this option   = ''||l_total  ); ',
'      if p_item.attribute_02 = ''Rows'' then',
'                wwv_flow.debug ('' start new row on zero = '' || (mod( l_total ,  num_cols)  ) );',
'      else ',
'                 wwv_flow.debug ('' start new row on zero  = '' || mod( l_total ,  ceil( actual_total  / num_cols ) ) ) ;',
'      end if  ;*/',
'      ',
'      if p_item.attribute_02 = ''Rows'' then',
'                wwv_flow.debug (''END OPTION  : this option = ''||l_total ||'', start new row on zero = '' || (mod( l_total ,  num_cols)  ) );',
'      else ',
'                wwv_flow.debug (''END OPTION: this option = ''||l_total ||'', start new row on zero = '' || mod( l_total , ceil( actual_total  / num_cols ) )) ;',
'      end if  ;',
'    end if; ',
'',
'',
'     if actual_total = l_total then',
'        htp.p(''</td></tr>''); ',
'     ',
'     elsif p_item.attribute_06  = ''Y'' and actual_total -1 = l_total  then ',
'       htp.p(''</td></tr>''); ',
'      ',
'     else ',
'',
'       if p_item.attribute_02 = ''Rows''  then ',
'         if  mod( l_total  ,  num_cols  ) = 0 then -- start new row ',
'            htp.p(''</td></tr>'');',
'         else -- start new column ',
'            htp.p(''</td>'');',
'         end if; ',
'       else  -- sort by columns ',
'         if  mod( l_total ,  ceil( actual_total  / num_cols) )  = 0    then -- start new column  ',
'            htp.p(''</td>''); ',
'         else -- continue current colunm ',
'             startcell := false ; ',
'         end if; ',
'       end if ; ',
'     end if; ',
'    ',
'end ; ',
'',
'procedure render_options( p_item  in apex_plugin.t_page_item,  p_value  in varchar2 , p_is_readonly in boolean ) ',
'is',
'l_column_value_list   apex_plugin_util.t_column_value_list;',
'l_selected boolean := false; ',
'  l_name          varchar2(30)    := apex_plugin.get_input_name_for_page_item(false);',
'  l_total number := 0; ',
'  actual_total number := 0;  ',
'  render_extra boolean := false;   ',
'  render_null  boolean := false;   ',
'  render_other boolean := false; ',
'  selected_value varchar2(1) ; ',
'  placeholder_value varchar2(2000) ; ',
'begin',
'',
'  ',
'  -- set the placeholder ',
'  placeholder_value := p_item.placeholder; ',
'  -- try to retrieve attribute_08',
'  /*',
'  begin ',
'   execute immediate '' ',
'     declare ',
'       ii apex_plugin.t_page_item; ',
'     begin ',
'       ii := :b1 ; ',
'       :b2 := ii.attribute_08; ',
'     end; ',
'   '' using in p_item , out placeholder_value ;',
'   exception when others then null; ',
'   end; ',
'   ',
'  -- try to retrieve placeholder  attribute ',
'  begin ',
'   execute immediate '' ',
'     declare ',
'       ii apex_plugin.t_page_item; ',
'     begin ',
'       ii := :b1 ; ',
'       :b2 := ii.placeholder; ',
'     end; ',
'   '' using in p_item , out placeholder_value ;',
'   exception when others then null; ',
'   end; ',
'*/ ',
'  ',
'',
'  l_column_value_list :=',
'        apex_plugin_util.get_data (',
'            p_sql_statement    => p_item.lov_definition,',
'            p_min_columns      => 2,',
'            p_max_columns      => 2,',
'            p_component_name   => p_item.name);',
' ',
'',
'    actual_total := l_column_value_list(1).count ; ',
'    ',
'    /* decide which Options to render and now many there will be */ ',
'    ',
'    -- is the current value in the lov. ',
'    for i in 1 .. l_column_value_list(1).count',
'    loop',
'      if  p_value = l_column_value_list(2)(i) then ',
'         l_selected := true;  -- found it ',
'        wwv_flow.debug( '' item value found in lov.'');',
'      else ',
'         wwv_flow.debug( '' item value not found in lov.'');',
'      end if; ',
'    end loop; ',
'  ',
'    -- "Other" option ',
'    if p_item.attribute_03 = ''Y''  then ',
'      actual_total :=  actual_total+1; ',
'      render_other:= true; ',
'      ',
'      if  p_value =  nvl(p_item.attribute_05 , ''Other'' )',
'      then ',
'         l_selected := true; -- found it ',
'         selected_value := ''O'' ;',
'      end if;       ',
'    end if; ',
'',
'    -- Null option ',
'    if p_item.lov_display_null   then ',
'      actual_total :=  actual_total+1; ',
'      render_null := true; ',
'      ',
'      if p_item.lov_null_value = p_value',
'      or ( p_value is null and p_item.lov_null_value is null )',
'      then ',
'        l_selected := true;  -- found it ',
'         selected_value := ''N'' ;',
'       end if;',
'    end if; ',
'    ',
'    -- extra value is enabled ',
'    if p_item.lov_display_extra ',
'    -- and  did not find a value in the LOV ',
'    and not l_selected ',
'    then ',
'      render_extra := true; ',
'      actual_total := actual_total + 1 ;',
'         selected_value := ''E'' ;',
'    end if; ',
'    ',
'    -- "Other" option ',
'    -- as a catchall when display extra is disabled and other is enabled ',
'    if render_other ',
'    and not p_item.lov_display_extra   ',
'    and p_value is not null ',
'    then       ',
'         l_selected := true; -- found it ',
'         selected_value := ''O'' ;      ',
'    end if; ',
'   ',
'    ',
'    if apex_application.g_debug then ',
'      wwv_flow.debug(',
'          '' render_other = ''||case when render_other then ''Y'' else ''N'' end ||',
'          '', render_extra = ''||case when render_extra then ''Y'' else ''N'' end ||',
'          '', render_null  = ''||case when render_null then ''Y'' else ''N'' end ||',
'          '', actual_total = ''||actual_total',
'      ); ',
'    end if ; ',
'    ',
'    /**** Start rendering *****/ ',
'    ',
'    htp.p(''<tr><td>'');',
' ',
' for i in 1 .. l_column_value_list(1).count',
'    loop',
'      if i > 1 then ',
'       start_option( l_total , p_item, actual_total  ) ; ',
'      end if; ',
'    ',
'        if apex_application.g_debug then',
'            wwv_flow.debug( l_column_value_list(1)(i)||'',''||l_column_value_list(2)(i));',
'        end if; ',
'        ',
'      if  p_value = l_column_value_list(2)(i) then ',
'         l_selected := true; ',
'      end if; ',
'    ',
'        sys.htp.p(''<div style="whitespace:no-wrap;" > ''||',
'            ''<input type="radio"  style="margin:5px 3px 5px 5px; "  name="''||l_name||''"  ''||',
'                   '' id="''||p_item.name||''_''||(i-1)||''" ''||',
'                 /*    case when p_is_readonly then '' readonly="readonly" '' end || */   ',
'                     ''value="''||',
'                           sys.htf.escape_sc(l_column_value_list(2)(i))||''"''|| -- value column',
'                     case when p_value = l_column_value_list(2)(i) then  '' checked="checked" ''  ',
'                          when p_is_readonly then '' disabled="disabled" ''  end || ',
'                    '' ''||p_item.element_option_attributes||'' ''||',
'            ''>''||',
'            ''<label for="''||p_item.name||''_''||(i-1)||''">''||sys.htf.escape_sc(l_column_value_list(1)(i))||''</label> '' ||-- display column ',
'            ''</div>''',
'            );',
'            ',
'       l_total := i; ',
'       end_option( l_total , p_item, actual_total  ) ; ',
'       ',
'    end loop;',
'    ',
'    ',
'    l_total := l_column_value_list(1).count ; ',
'',
'    if render_extra then ',
'',
'      start_option( l_total , p_item, actual_total  ) ; ',
'      ',
'        sys.htp.p(''<div style="whitespace:no-wrap;" > ''||',
'        ''<input type="radio"    style="margin:5px 3px 5px 5px; "     name="''||l_name||''"  ''|| ',
'                ''id="''||p_item.name||''_''||l_total ||''" ''||',
'               /* case when p_is_readonly then '' readonly="readonly" '' end || */ ',
'        '' value="''||sys.htf.escape_sc(p_value)|| ''" checked="checked" ''    || '' />''||',
'        ''<label for="''||p_item.name||''_''||l_total  ||''">''|| nvl(sys.htf.escape_sc(p_value), ''(null)'') ||''</label> ''||',
'       ''</div>''',
'        ); ',
'      l_total := l_total + 1; ',
'      end_option( l_total , p_item , actual_total  ) ; ',
'    end if; ',
'',
'',
'',
'    --if p_item.lov_display_null  then',
'    if render_null then ',
'    start_option( l_total , p_item, actual_total  ) ;  ',
'      ',
'        sys.htp.p(''<div style="whitespace:no-wrap;" > ''||',
'        ''<input type="radio"    style="margin:5px 3px 5px 5px; "   name="''||l_name||''"  id="''||p_item.name||''_''||l_total ||''" ''||',
'          case when p_is_readonly then '' readonly="readonly" '' end || ',
'        '' value="''||nvl( sys.htf.escape_sc(p_item.lov_null_value), '''')|| ''" ''||',
'          case ',
'              --when p_item.lov_null_value = p_value ',
'              --or ( p_value is null and p_item.lov_null_value is null ) ',
'              when selected_value = ''N''     ',
'              then   '' checked="checked" '' ',
'              when p_is_readonly then '' disabled="disabled" ''  end     || ',
'            '' />''||',
'        ''<label for="''||p_item.name||''_''||l_total  ||''">''|| nvl( sys.htf.escape_sc(p_item.lov_null_text), ''Null'')  ||''</label> ''||',
'       ''</div>''',
'        ); ',
'',
'      l_total := l_total + 1; ',
'      end_option( l_total , p_item, actual_total  ) ; ',
'      ',
'    end if; ',
'',
'   if render_other then ',
'',
'     start_option( l_total , p_item, actual_total  ) ;  ',
'    ',
'    sys.htp.p(''<div style="whitespace:no-wrap;" > ''||',
'        ''<input type="radio"   style="margin:5px 3px 5px 5px; "   name="''||l_name||''"  ''||',
'                 case when p_is_readonly then '' readonly="readonly" '' end || ',
'                 '' id="''||p_item.name||''_''||l_total  ||''" ''||',
'               '' value''|| case ',
'                              --when not l_selected and p_value is not null ',
'                              when selected_value = ''O'' ',
'                              then ''="''||sys.htf.escape_sc(p_value) || ''" checked="checked" '' ',
'                              else ''="''||p_item.attribute_05|| ''" ''  -- default value for "Other" option. ',
'                          end   ||',
'                 case when nvl(selected_value,''X'')   <> ''O'' and p_is_readonly   then '' disabled="disabled" '' end || ',
'         '' />''||',
'        ''<label for="''||p_item.name||''_''||l_total ||''">''||p_item.attribute_04||''</label> ''',
'        ); ',
'        sys.htp.p(',
'          ''<input onChange=" var v = $(this).val(); var n = $(''''#''||p_item.name||''_''||l_total ||'''''');  n.val( v ) ;  "  ''||',
'                ''  onKeyup=" var v = $(this).val(); var n = $(''''#''||p_item.name||''_''||l_total ||''''''); if (v.length > 0 ) n.prop(''''checked'''', true);  n.val( v ) ;  " ''||',
'                   ''value="''|| case when /*not l_selected */ selected_value = ''O'' then  sys.htf.escape_sc(p_value)  end ||''" ''||',
'                    '' class="advanced_radio_other_text_input" size="''||p_item.element_width||''"  maxlength="''||p_item.element_max_length||''" ''||',
'                     case when p_is_readonly then '' disabled="disabled" '' end || ',
'                    ''placeholder="''|| placeholder_value  ||''"''||',
'             ''></input></div>''',
'    );-- display column ',
'    ',
'      l_total := l_total + 1; ',
'    end_option( l_total , p_item, actual_total ) ;  ',
'    ',
'    end if; ',
'    ',
'    ',
'end;',
' ',
'',
'',
'function advanced_radio_ajax(p_item   in apex_plugin.t_page_item,',
'                          p_plugin in apex_plugin.t_plugin )',
'    return apex_plugin.t_page_item_ajax_result',
'',
'as',
'l_ret apex_plugin.t_page_item_ajax_result;',
'begin',
'',
'apex_plugin_util.print_lov_as_json(p_item.lov_definition,',
'                                  p_item.name,',
'                                  true);',
'return l_ret;',
'end;',
'',
'',
'function  render_advanced_radio (',
'    p_item                in apex_plugin.t_page_item,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_value               in varchar2,',
'    p_is_readonly         in boolean,',
'    p_is_printer_friendly in boolean )',
'    return apex_plugin.t_page_item_render_result',
' ',
'is',
'',
'',
'l_result apex_plugin.t_page_item_render_result;',
' ',
'c_title_param apex_application_page_items.attribute_01%type:=nvl(p_item.attribute_01, ''Select one or more items'');',
'c_style apex_application_page_items.attribute_02%type:=p_item.attribute_02;',
'',
'begin ',
'',
'',
'if apex_application.g_debug then',
'apex_plugin_util.debug_page_item( p_plugin, p_item, p_value, p_is_readonly, p_is_printer_friendly);',
'end if;',
'',
'apex_javascript.add_onload_code (',
'    ',
'    p_code => ''',
'       oldsub = apex.submit ; ',
'       apex.submit = function() {',
'       $(''''.advanced_radio_other_text_input'''').prop(''''disabled'''', ''''disabled'''');',
'       oldsub ();',
'       } '',  -- the key means it can only be added once on a page ',
'       p_key => ''advanced_radio_other_text_input_init'' /* ||p_item.name */',
'    ',
');',
'                  ',
'          ',
'',
'',
'htp.p(''<fieldset class="radio_group''||p_item.element_attributes||'' name="''||apex_plugin.GET_INPUT_NAME_FOR_PAGE_ITEM(true)||',
'''" id="''||p_item.name||''"  title="''||c_title_param||''"><table style="border-spacing:0; "> '');    ',
' ',
' render_options(p_item, p_value , p_is_readonly );',
'htp.p(''</table></fieldset>'');',
'return l_result;',
'END;',
''))
,p_render_function=>'render_advanced_radio'
,p_ajax_function=>'advanced_radio_ajax'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:SOURCE:ELEMENT:WIDTH:ELEMENT_OPTION:PLACEHOLDER:LOV:LOV_REQUIRED:LOV_DISPLAY_NULL:CASCADING_LOV'
,p_sql_min_column_count=>2
,p_sql_max_column_count=>2
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'element_max_length:max characters allowed in other text field ',
'',
'lov_display_extra: after saving, any value entered into Other is displayed as an extra selected radio option. If this option is enabled, other will never be selected after saving. ',
'',
'lov_display_null: if selected, displays this option before "Other"'))
,p_version_identifier=>'1.0'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24522664207112408043)
,p_plugin_id=>wwv_flow_api.id(24522654590973709232)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Number of Columns'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'1'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24522664813282414375)
,p_plugin_id=>wwv_flow_api.id(24522654590973709232)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Sort By'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'Columns'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(24522664207112408043)
,p_depending_on_condition_type=>'NOT_IN_LIST'
,p_depending_on_expression=>'0,1'
,p_lov_type=>'STATIC'
,p_help_text=>'When you have more than one radio column, you can sort your options by row or column, apex radio groups only sort by rows.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(24522666041171418041)
,p_plugin_attribute_id=>wwv_flow_api.id(24522664813282414375)
,p_display_sequence=>10
,p_display_value=>'Rows'
,p_return_value=>'Rows'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(24522666395180418917)
,p_plugin_attribute_id=>wwv_flow_api.id(24522664813282414375)
,p_display_sequence=>20
,p_display_value=>'Columns'
,p_return_value=>'Columns'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24522677463108440736)
,p_plugin_id=>wwv_flow_api.id(24522654590973709232)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Enable Other Option'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_help_text=>'Set this to No, if you want this radio group to appear like a normal apex radio group and disable the "Other" option and its text box.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24522682300485550856)
,p_plugin_id=>wwv_flow_api.id(24522654590973709232)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Other display text'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Other'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(24522677463108440736)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Change the value of "Other" to something else. ie. "Other, please specify." or leave it blank, and the option will just show the text input box without a label.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24520666800642783551)
,p_plugin_id=>wwv_flow_api.id(24522654590973709232)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Other return value'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Other'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(24522677463108440736)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'This is the value returned when The Other option is selected, but no value entered into the text box.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24522686132924631185)
,p_plugin_id=>wwv_flow_api.id(24522654590973709232)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Start other option on new line'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(24522677463108440736)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Force "Other" option with text box onto its own line at the end of the radio group.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24522692960346857812)
,p_plugin_id=>wwv_flow_api.id(24522654590973709232)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Allow final options to span columns'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(24522664207112408043)
,p_depending_on_condition_type=>'NOT_IN_LIST'
,p_depending_on_expression=>'0,1'
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'If the number of Options does not fit neatly into the number of columns, the last row will have less options, this allows the last option to fill remaining columns. This is useful if there is one display value that has more characters than others. ',
'Also applies to the "Other" option, and may apply to the last two rows if the "Other" option is set display on a new line.'))
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
