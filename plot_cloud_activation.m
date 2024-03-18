function out = plot_cloud_activation(ncfile)
    %Plot a time series of CDP DSDs from SPICULE
    
    %Get water data from the netCDF file
    time = ncread(ncfile,'Time');
    conc_cdp = ncread(ncfile, 'CONCD_LWO');
    conc_2ds = ncread(ncfile,'CONCS_2DS');
    % vxl = ncread(ncfile,'VMR_VXL');
    % H2o_pic1 = ncread(ncfile,'H2O_WVISO1');
    % H2o_pic2 = ncread(ncfile,'H2O_WVISO2');
    
    %Get CN data
    cn = ncread(ncfile,'CONCN'); % #/cm3
    pcas = ncread(ncfile,'CONCP_RWO'); % #/cm3
    uhsas = ncread(ncfile,'CONCU_WYO'); % #/cm3


    %Get cloud droplet data
    hvps = ncread(ncfile,'TACT2V_HVPS');
    nevzorov_lwc = ncread(ncfile,'VCOLLWC_NEV');
    nevzorov_lwc_ref = ncread(ncfile,'VREFLWC_NEV');

    flightnumber = upper(ncreadatt(ncfile, '/', 'FlightNumber'));
    flightdate = ncreadatt(ncfile, '/', 'FlightDate');
    time_ref = split(flightdate, "/");
    time = datetime(str2double(time_ref{3}),str2double(time_ref{1}),str2double(time_ref{2})) + seconds(time(:,1));
    
    function mypostcallback(obj,evd,AX)
        datetick('x', 'keeplimits'); % update dateticks on the 1st axis
    end
    
    %Make figure
    figure(1);
    tiledlayout(3,1);
    
    %Water Info
    ax1 = nexttile;
    yyaxis left
    plot(datenum(time), vxl,"DisplayName", "VXL (ppmv)", "Color","r", "LineStyle", "-", "LineWidth", 2); hold on
    plot(datenum(time), H2o_pic1, "DisplayName", "Picarro 1 H20 (ppmv)", "Color","g", "LineStyle", "-", "LineWidth", 2); hold on
    plot(datenum(time), H2o_pic2,"DisplayName", "Picarro 2 H20(ppmv)", "Color","b", "LineStyle", "-", "LineWidth", 2); hold on
    ylabel('Water (ppmv)');

    yyaxis right
    plot(datenum(time), conc_cdp, "DisplayName", "CDP (#/cm3)", "Color","c", "LineStyle", "-");hold on
    plot(datenum(time), conc_2ds, "DisplayName", "2DS (#/cm3)", "Color","m", "LineStyle", "-");hold on
    ylabel('Cloud probes (#/cm3)');

    datetick('x');
    test = gca(); 
    test.XTick = linspace(test.XTick(1),test.XTick(end),1000); 
    grid on
    xlabel('Time (s)')
    legend();
    title([flightnumber ' ' flightdate]);
    
    %CVI flows
    ax2 = nexttile;
    yyaxis left
    plot(datenum(time), dryflow,"DisplayName", "Dry Flow (slpm)", "Color","r", "LineStyle", "-"); hold on
    plot(datenum(time), user_flow, "DisplayName", "User flow (slpm)", "Color","g", "LineStyle", "-"); hold on
    plot(datenum(time), bypass_flow,"DisplayName", "Bypass flow(slpm)", "Color","b", "LineStyle", "-"); hold on
    ylabel('Flows (slpm)');
    datetick('x')
    xlabel('Time (s)')
    ylabel('CVI flows (slpm)')
    legend
    grid on

    %Additional cloud info
    ax3 = nexttile;
    yyaxis left
    plot(datenum(time), nevzorov_lwc, "DisplayName", "Nevzorov LWC", "Color","r", "LineStyle", "-"); hold on
    plot(datenum(time), nevzorov_lwc_ref, "DisplayName", "Nevzorov voltage reference", "Color","g", "LineStyle", "-"); hold on
    ylabel('Nevzorov LWC signal');

    yyaxis right
    plot(datenum(time), hvps, "DisplayName", "HVPS (counts)", "Color","c", "LineStyle", "-","LineWidth", 2);hold on
    ylabel('HVPS particle counts');
    datetick('x')
    xlabel('Time (s)')
    ylabel('LWC (g/m3)')
    legend
    grid on
    
    %Link axes for panning and zooming
    linkaxes([ax1, ax2, ax3],'x');
    zoom xon;  %Zoom x-axis only
    pan;  %Toggling pan twice seems to trigger desired behavior, not sure why
    pan;
    
end