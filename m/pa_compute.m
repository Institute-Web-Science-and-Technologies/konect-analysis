%
% Compute the preferential attachment tests. 
%
% PARAMETERS 
%	$NETWORK
%
% INPUT 
% 	dat/split.$NETWORK.mat
%	dat/info.$NETWORK
%
% OUTPUT 
%	dat/pa.$NETWORK.mat
%		Parameters of the fits
%		.pa
%			.a, .u, .v
%				.$METHOD (see pa_compute_one.m)
%	dat/pa_data.$NETWORK.mat
%		Additional data used to plot the fits 
%

network = getenv('NETWORK') 

consts = konect_consts(); 

info = read_info(network)

split = load(sprintf('dat/split.%s.mat', network)); 

if info.weights == consts.POSITIVE & size(split.T_source,2) >= 3
    T_1 = [ split.T_source(:,1:3) ; split.T_target(:,1:3) ];
    T_2 = split.T_test(:,1:3); 
else
    T_1 = [ split.T_source(:,1:2) ; split.T_target(:,1:2) ];
    T_2 = split.T_test(:,1:2); 
end

size_T_1 = size(T_1)
size_T_2 = size(T_2)

if info.weights == consts.POSITIVE && size(split.T_source,2) >= 3 ... 
        && 0 == sum(split.T_source(:,3) ~= floor(split.T_source(:,3))) ...
        && 0 == sum(split.T_target(:,3) ~= floor(split.T_target(:,3))) ...
        && 0 == sum(split.T_test(:,3)   ~= floor(split.T_test(:,3)))
    w_1 = T_1(:,3);
    w_2 = T_2(:,3); 
    ww_1 = [ w_1 ; w_1 ]; 
    ww_2 = [ w_2 ; w_2 ]; 
else
    w_1 = 1;
    w_2 = 1; 
    ww_1 = 1;
    ww_2 = 1; 
end

size_w_1 = size(w_1)
size_w_2 = size(w_2)

pa = struct(); 

if info.format == consts.ASYM 

    letter = 'u'
    [ pa.u pa_data.u ] = pa_compute_one(T_1(:,1), w_1, T_2(:,1), w_2); 
    letter = 'v'
    [ pa.v pa_data.v ] = pa_compute_one(T_1(:,2), w_1, T_2(:,2), w_2); 

    i_1 = [ T_1(:,1) ; T_1(:,2) ]; 
    i_2 = [ T_2(:,1) ; T_2(:,2) ]; 
    
    letter = 'a'
    [ pa.a pa_data.a ] = pa_compute_one(i_1, ww_1, i_2, ww_2);

elseif info.format == consts.SYM 

    i_1 = [ T_1(:,1) ; T_1(:,2) ]; 
    i_2 = [ T_2(:,1) ; T_2(:,2) ]; 

    [ pa.a pa_data.a ] = pa_compute_one(i_1, ww_1, i_2, ww_2);

elseif info.format == consts.BIP

    [ pa.u pa_data.u ] = pa_compute_one(T_1(:,1), w_1, T_2(:,1), w_2); 
    [ pa.v pa_data.v ] = pa_compute_one(T_1(:,2), w_1, T_2(:,2), w_2); 

    i_1 = [ T_1(:,1) ; (T_1(:,2) + info.n1) ]; 
    i_2 = [ T_2(:,1) ; (T_2(:,2) + info.n1) ]; 

    [ pa.a pa_data.a ] = pa_compute_one(i_1, ww_1, i_2, ww_2);

else
    error('*** Invalid format'); 
end

save(sprintf('dat/pa.%s.mat', network), '-v7.3', 'pa'); 

save(sprintf('dat/pa_data.%s.mat', network), '-v7.3', 'pa_data'); 
