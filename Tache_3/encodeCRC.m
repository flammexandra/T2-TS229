function [encodedBits] = encodeCRC(P,bits)
    crc_generator = comm.CRCGenerator(Polynomial = P);
    encodedBits = step(crc_generator, bits(:));
end

