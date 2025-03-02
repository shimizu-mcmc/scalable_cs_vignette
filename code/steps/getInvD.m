function invD=getInvD(b,v_,R_)
n=size(b,2);
invD = wishrnd(inv(R_+b*b'),v_+ n);
end 