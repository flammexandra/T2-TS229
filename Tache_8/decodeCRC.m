function [error] = decodeCRC(P, msg_sortie)
    H = comm.CRCDetector(P);
    [pck,error] = H.step(msg_sortie(:));

end
