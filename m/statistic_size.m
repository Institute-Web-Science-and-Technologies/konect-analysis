%
% Compute the size statistic of a network. 
%
% PARAMETERS 
%	$NETWORK 
%
% INPUT 
%	dat/info.$NETWORK
%
% OUTPUT 
%	dat/statistic.size.$NETWORK
%

network = getenv('NETWORK');

info = read_info(network); 

consts = konect_consts(); 

if info.format == consts.BIP

  values = [ info.n1 + info.n2 ; info.n1 ; info.n2 ]; 

else

  % TODO:  for ASYM networks, also output the number of nodes with
  % nonzero number of outlinks and inlinks.  

  values = [ info.n1 ]; 

end

OUT= fopen(sprintf('dat/statistic.size.%s', network), 'w');
if OUT < 0, 
    error('fopen');
end

fprintf(OUT, '%u\n', values);

if 0 > fclose(OUT)
    error('fclose'); 
end
