create or replace package body gumroad as 

procedure fetch_license_key (p_product_permalink varchar2, p_license_key in varchar2) is 
   response varchar2(32000);
   email varchar2(120);
begin 
   apex_web_service.g_request_headers.delete();
   apex_web_service.g_request_headers(1).name := 'content-type';
   apex_web_service.g_request_headers(1).value := 'application/x-www-form-urlencoded'; 
   response := apex_web_service.make_rest_request (
      p_url         => 'https://api.gumroad.com/v2/licenses/verify', 
      p_http_method => 'POST',
      p_parm_name   => apex_util.string_to_table('product_permalink:license_key'),
      p_parm_value  => apex_util.string_to_table(p_product_permalink||':'||p_license_key));
      arcsql.debug(response);
   apex_json.parse(response);
   email := apex_json.get_varchar2(p_path => 'purchase.email');
   if apex_json.get_boolean(p_path => 'success') then 
      arcsql.debug(email||': success');
   end if;
exception
   when others then 
      arcsql.log_err(error_text=>'fetch_license_key: '||dbms_utility.format_error_stack);
      raise;
end;

end;
/
