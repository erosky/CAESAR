function out = plot_ice_isotope(ncfile)
    %Plot a time series of CDP DSDs from SPICULE
    datetime.setDefaultFormats('default','HH:mm:ss (yyyy-MM-dd)')
    
    %Get water data from the netCDF file
    time = ncread(ncfile,'Time');
    conc_cdp = ncread(ncfile, 'CONCD_LWO');
    conc_2ds = ncread(ncfile,'TACT2V_2DS');
    vxl = ncread(ncfile,'VMR_VXL');
    H2o_pic1 = ncread(ncfile,'H2O_WVISO1');
    H2o_pic2 = ncread(ncfile,'H2O_WVISO2');
    
    %Get isotopes
    dD_1 = ncread(ncfile,'dD_WVISO1');
    dD_2 = ncread(ncfile,'dD_WVISO2');
    d180_1 = ncread(ncfile,'d18O_WVISO1');
    d180_2 = ncread(ncfile,'d18O_WVISO2');

    %Additional cloud data
    hvps = ncread(ncfile,'TACT2V_HVPS');
    nevzorov_lwc = ncread(ncfile,'VCOLLWC_NEV');
    nevzorov_lwc_ref = ncread(ncfile,'VREFLWC_NEV');

    % Flight data
    altitude = ncread(ncfile,'GGALT');

    flightnumber = upper(ncreadatt(ncfile, '/', 'FlightNumber'));
    flightdate = ncreadatt(ncfile, '/', 'FlightDate');
    time_ref = split(flightdate, "/");
    time = datetime(str2double(time_ref{3}),str2double(time_ref{1}),str2double(time_ref{2})) + seconds(time(:,1));
    
    
    %Make figure
    figure(1);
    tiledlayout(3,1);
    
    %Ice habits
    ax1 = nexttile;
    yyaxis left
    p1 = plot(datenum(time), hvps, "DisplayName", "HVPS (100um - 10mm)", "Color","g", "LineStyle", "-","LineWidth", 2);hold on
    p2 = plot(datenum(time), conc_2ds, "DisplayName", "2DS (10 - 1000 um)", "Color","c", "LineStyle", "-"); hold on 
    ylabel('OAP particle counts');
        xticks('auto')

    yyaxis right
    %plot(datenum(time), conc_cdp, "DisplayName", "CDP (5 - 35 um)", "Color","b", "LineStyle", "-"); hold on

    ylabel('CDP and 2DS (#/cm3)');

    datetick('x');
    grid on
    xlabel('Time')
    legend();
    title([flightnumber ' ' flightdate]);
    
    datatipRow = dataTipTextRow('UTC',time);
    p1.DataTipTemplate.DataTipRows(end+1) = datatipRow;
    p2.DataTipTemplate.DataTipRows(end+1) = datatipRow;
    
    %isotopes
    ax2 = nexttile;
    yyaxis left
    p3 = plot(datenum(time), dD_1, "DisplayName", "dD (CVI)", "Color","r", "LineStyle", "-"); hold on
    plot(datenum(time), d180_1, "DisplayName", "d180 (CVI)", "Color","g", "LineStyle", "-"); hold on
    ylabel('Condensate isotopic signal');
    
    p3.DataTipTemplate.DataTipRows(end+1) = datatipRow;

    % yyaxis right
    % plot(datenum(time), dD_2, "DisplayName", "dD (SDI)", "Color","m", "LineStyle", "-","LineWidth", 2);hold on
    % plot(datenum(time), d180_2, "DisplayName", "d180 (SDI)", "Color","b",
    % "LineStyle", "-","LineWidth", 2);hold on
    % ylabel('Total water isotopic signature');
    
    datetick('x')
    xlabel('Time')
    legend
    grid on

    ax3 = nexttile;
    yyaxis left
    p5 = plot(datenum(time), altitude, "DisplayName", "Altitude (m)", "Color","g", "LineStyle", "-","LineWidth", 2);hold on
    ylabel('Flight Altitude');
    
    p5.DataTipTemplate.DataTipRows(end+1) = datatipRow;

    datetick('x');
    grid on
    xlabel('Time')
    legend();
    title([flightnumber ' ' flightdate]);
    
    
    %Link axes for panning and zooming
    linkaxes([ax1, ax2, ax3],'x');
    zoom xon;  %Zoom x-axis only
    pan;  %Toggling pan twice seems to trigger desired behavior, not sure why
    pan;
    
end