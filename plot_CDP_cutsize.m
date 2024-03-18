function out = plot_CDP_cutsize(ncfile)
    %Plot a time series of CDP DSDs from SPICULE
    
    %Get water data from the netCDF file
    time = ncread(ncfile,'Time');
    conc_cdp = ncread(ncfile, 'CONCD_LWO');
    cdp_diameter = ncread(ncfile, 'DBARD_LWO');
    count_2ds = ncread(ncfile,'TACT2V_2DS');
    vxl = ncread(ncfile,'VMR_VXL');
    H2o_pic1 = ncread(ncfile,'H2O_WVISO1');
    H2o_pic2 = ncread(ncfile,'H2O_WVISO2');
    king = ncread(ncfile,'PLWCC');

    flight_alt = ncread(ncfile,'GGALT');
    
    %Get cvi flows
    dryflow = ncread(ncfile,'DRYFLW_CVI');
    bypass_flow = ncread(ncfile,'BYPFLW_CVI');
    user_flow = ncread(ncfile,'USRFLW_CVI');

    %Additional cloud data
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

    
    % Picarro 2 - Total water (vapor and condensed)
    ax1 = nexttile;
    yyaxis left
    plot(datenum(time), H2o_pic1, "DisplayName", "Picarro 1 H20 (ppmv)", "Color","g", "LineStyle", "-", "LineWidth", 2); hold on
    ylabel('H2O (ppmv)');
    datetick('x')
    xlabel('Time (s)')
    legend
    title('Condensed water in Picarro 1')
    subtitle([flightnumber ' ' flightdate]);

    yyaxis right
    plot(datenum(time), flight_alt, "DisplayName", "Flight altitude (m)", "Color","r", "LineStyle", "-", "LineWidth", 1); hold on
    ylabel('altitude (m)');




    %Additional cloud info
    ax2 = nexttile;
    yyaxis left
    plot(datenum(time), conc_cdp, "DisplayName", "CDP (5 - 35 um)", "Color","c", "LineStyle", "-");hold on
    ylabel('Cloud droplet concentration (#/cm3)');

    yyaxis right
    % plot(datenum(time), king, "DisplayName", "King probe LWC", "Color","r", "LineStyle", "-"); hold on
    plot(datenum(time), cdp_diameter, "DisplayName", "Mean droplet diameter", "Color","r", "LineStyle", "-"); hold on
    ylabel('CDP mean diameter');
    %ylabel('King proble LWC');
    datetick('x')
    xlabel('Time (s)')
    legend
    title('CDP concentration and diameter')
    grid on


    % Picarro 1 - Liquid and Ice
    ax3 = nexttile;
    yyaxis left
    plot(datenum(time), hvps, "DisplayName", "HVPS (100um - 10mm)", "Color","c", "LineStyle", "-","LineWidth", 2);hold on
    ylabel('HVPS particle counts');
    %ylim([0 2000]);

    yyaxis right
    plot(datenum(time), count_2ds, "DisplayName", "2DS (10 - 1000 um)", "Color","m", "LineStyle", "-");hold on
    ylabel('2DS particle counts');
    datetick('x')
    xlabel('Time (s)')
    ylabel('Particle Counts')
    legend
    title('Cloud probe data (large particles)')


    datetick('x');
    % test = gca(); 
    % test.XTick = linspace(test.XTick(1),test.XTick(end),1000); 
    grid on
    xlabel('Time (s)')
    legend();


    
    %Link axes for panning and zooming
    linkaxes([ax1, ax2, ax3],'x');
    zoom xon;  %Zoom x-axis only
    pan;  %Toggling pan twice seems to trigger desired behavior, not sure why
    pan;
    
end