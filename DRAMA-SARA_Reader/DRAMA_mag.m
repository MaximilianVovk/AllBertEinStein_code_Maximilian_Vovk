clc
clear all
close all
%%
run('DRAMA_data.m')

% Trajectory = [Trajectory{2,1}(1:end-1,:);Trajectory{1,1}];
Trajectory = [Trajectory{1,1}];

obs.x_init = Trajectory(end,6)*1000;
obs.y_init = 0;
obs.z_init = 10000;


h_dist = sqrt((Trajectory(:,6)*1000 - obs.x_init).^2 + (Trajectory(:,2)*1000 - obs.z_init).^2 + obs.y_init^2);  % distance respec to the observer

for ii=1:max(size(AeroThermalHistory))
    lum_eff = 0.282 .* (AeroThermalHistory{ii,1}(1,4)).^(-0.33);% 0.213 .* (AeroThermalHistory{ii,1}(1,4)).^(-0.17); %(1,4) in 1 -> 2:end % smallest value 1e-3; FRIPON%
    vel=(1000*Trajectory(2:max(size(AeroThermalHistory{ii,1})),5));
    mass_sec= abs((AeroThermalHistory{ii,1}(2:end,4))-(AeroThermalHistory{ii,1}(1:end-1,4)))./abs((AeroThermalHistory{ii,1}(2:end,1))-(AeroThermalHistory{ii,1}(1:end-1,1)));
    dist= h_dist(2:max(size(AeroThermalHistory{ii,1})));
    luminous_energy = 0.5 .* vel.^2 .* mass_sec.* lum_eff ;%.* 1e10 ./ (dist.^2); lum_eff
    luminous_energy(luminous_energy==0)=nan;
    mv{ii} = 6.8 - 1.086 * log(luminous_energy);  %# magnitude before 2.086 but in -1.086 kampbel-brown & koshny
    
    figure(1)
    plot((AeroThermalHistory{ii,1}(2:end,1)),mv{ii})
    hold on
   
    figure(2)
    plot(mv{ii},(AeroThermalHistory{ii,1}(2:end,2)))
    hold on
end
names=[];
for ii=1:max(size(AeroThermalHistory))
    names=[names string(AeroThermalHistory{ii,2})];
end

figure(1)
legend(names,'Interpreter', 'none','Location','best')
xlabel('Time [s]') 
ylabel('Magnitude [-]')
%ylim([-2 9])
grid on
set(gca, 'YDir','reverse')

figure(2)
ylim([0 (AeroThermalHistory{1,1}(1,2))])
legend(names,'Interpreter', 'none','Location','best')
ylabel('Altitude [km]') 
xlabel('Magnitude [-]')
%xlim([-2 9])
grid on
set(gca, 'XDir','reverse')

% [rho_air,a_air,T_air,P_air,nu_air,h,sigma] = atmos(ast.h(t));
% heat_stag(t)=1.7415e-4*(rho_air/ast.r(t+1))^0.5*ast.v(t+1)^3; %J/s/m^2 experimental sutton graves formula
% T_stagnationPoint=(heat_stag(t)/(ast.emissivity*Stefan_Boltzmann_cost))^(1/4);
% figure(3)
% plot((AeroThermalHistory{1,1}(2:end,3)),(AeroThermalHistory{1,1}(2:end,2)))
% title('Temperature')
% ylabel('Altitude [km]') 
% xlabel('Temperature [K]')
% grid on

Initial_Asteroid_Mass = AeroThermalHistory{1,1}(1,4)
Final_Asteroid_Mass =AeroThermalHistory{1,1}(end,4)