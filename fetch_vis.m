% Visibility algorithm/find fetch demo
% Rose Palermo - Updated May 5 2021
% This demo shows a calculation of the fetch around a lake using the
% visilibity1 algorithm, assuming isotropic winds.

% INPUT: shoreline - shoreline of a lake, formatted such that it is one cell with the
% first element the shoreline points in order and subsequent elements are
% ordered island points. Shoreline ordering should be CW and island
% ordering should be CCW.

% OUTPUT: All fetch and associated cos(phi-theta) for each point on the
% shoreline. 

% (Una, you'll want to use the cos(phi-theta) to find phi and theta for
% limiting wind directions
%% before running the demo, need to mex things in the src folder (see ReadMe)
% mex -setup
% mex -v in_environment.cpp visilibity.o
% mex -v visibility_polygon.cpp visilibity.o
%% load example input
load('example_input.mat')

%% run

% parameters for visibility functions
eps = 0.1;
epsilon = 1e-4;
snap_distance = 0.05; % Looks like we get some invalid (empty array) visibility polygons if snap_distance >= eps.

% find fetch polygon for each point
WaveArea = cell(length(shorelines),1);

for k = 1:length(shorelines)
    WaveArea{k,1} = zeros(length(shorelines{k}),1);
    ind{k} = find(shorelines{k});
    for l = 1:length(shorelines{k})
        
        % Get the next and previous points.
        l_ind = find(ind{k} == l);
        if l_ind > 1
            l_ind_prev = l_ind-1;
        else
            l_ind_prev = length(ind{k});
        end
        
        if l_ind < length(ind{k})
            l_ind_next = l_ind+1;
        else
            l_ind_next = 1;
        end
        
        xp = shorelines{k}(ind{k}(l_ind_prev), 1);
        yp = shorelines{k}(ind{k}(l_ind_prev), 2);
        xn = shorelines{k}(ind{k}(l_ind_next), 1);
        yn = shorelines{k}(ind{k}(l_ind_next), 2);
        
        % Get the observer position.
        if k == 1 % this is the lake
            [Pobs,nbi] = Pint([xn,yn],[x_l,y_l],[xp,yp],eps);
        else % this is an island
            [Pobs,nbi] = Pint([xp,yp],[x_l,y_l],[xn,yn],eps);
        end
        
        V = visibility_polygon(Pobs, shorelines, epsilon, snap_distance);
        
        
        % fetch & wave area & distance & cos(theta-phi)
        FetchArea{k,1}(l,1) = polyarea(V(:,1),V(:,2));
        Fetch_dist = sqrt(sum(([shorelines{k}(l,1),shorelines{k}(l,2)] - V).^2,2));
        minFetch_dist = min(Fetch_dist,200); % this is how we can limit fetch eventually
        % Wave weighting = (F)*cosang
        weighted_fetch_dist = ([shorelines{k}(l,1),shorelines{k}(l,2)] - V)*nbi'; % magnitude of fetch * magnitude of normal vector * cosang
        % cos(theta - phi) = dot product of slvec and losvec
        cosang = -weighted_fetch_dist./Fetch_dist; %[mag_fetch*mag_norm(which is 1)*cosang]/mag_fetch = cosang
        cosang(isnan(cosang)) = 0;
        cosang(cosang<0) = 0; % any less than 0 are artifacts of discritezation and not physical
        Wavepts = [shorelines{k}(l,1),shorelines{k}(l,2)]+(V-[shorelines{k}(l,1),shorelines{k}(l,2)]).*cosang;
        WaveArea{k,1}(l,1) = polyarea(Wavepts(:,1),Wavepts(:,2));
        
    end
end
