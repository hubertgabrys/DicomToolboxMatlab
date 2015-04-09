function surface = hg_volume2surf( V )
%hg_volume2surf transforms volume to surface by subtracting eroded volume
%from the original volume.
%   V is binary 3-dimensional structure.

V_eroded = convn(logical(V),ones(3,3,3)/9,'same')>=3;
surface = V - V_eroded;

end

