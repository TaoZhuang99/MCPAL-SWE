% dim: nu1->mu1->nu2->mu2->la
function Gaunt_coeff = Gaunt_coeff_audio_new(nuMax)
    Gaunt_coeff = zeros(nuMax+1,2*nuMax+1,nuMax+1,2*nuMax+1,4*nuMax+2);
    for nu1 = 0:nuMax
        for mu1 = -nu1:nu1
            for nu2 = 0:nuMax
                for mu2 = -nu2:nu2
                    for la = 0:(4*nuMax+1)
                        Gaunt_coeff(nu1+1,mu1+nuMax+1,nu2+1,mu2+nuMax+1,la+1) = ... 
                            Gaunt(nu1, mu1, nu2, -mu2, la);
                    end
                end
            end
        end
    end
end