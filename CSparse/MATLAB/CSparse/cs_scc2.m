function [p, q, r, s] = cs_scc2 (A, bipartite)
%CS_SCC2 strongly-connected components of a square or rectangular sparse matrix.
%   [p,q,r,s] = cs_scc2(A) finds a permutation p so that A(p,q) is permuted into
%   block upper triangular form (if A is square).  In this case, r=s, p=q and
%   the kth diagonal block is given by A (t,t) where t = r(k):r(k)+1. 
%   The diagonal of A is ignored.  Each block is one strongly connected
%   component of A.
%
%   If A is not square (or for [p,q,r,s] = cs_scc2(A,1)), then the connected
%   components of the bipartite graph of A are found.  A(p,q) is permuted into
%   block diagonal form, where the diagonal blocks are rectangular.  The kth
%   block is given by A(r(k):r(k)+1,s(k):s(k)+1).  A can be rectangular.
%
%   Example:
%       Prob = UFget ('HB/arc130') ; A = Prob.A ; [p q r s] = cs_scc2 (A) ;
%       cspy (A (p,q)) ;
%       Prob = UFget ('HB/wm1') ; A = Prob.A ; [p q r s] = cs_scc2 (A) ;
%       cspy (A (p,q)) ;
%
%   See also CS_DMPERM, DMPERM, CS_SCC, CCSPY.

%   Copyright 2006, Timothy A. Davis.
%   http://www.cise.ufl.edu/research/sparse

[m n] = size (A) ;
if (m ~= n | (nargin > 1 & bipartite))

    % find the connected components of [I A ; A' 0]
    S = spaugment (A) ;
    [psym,rsym] = cs_scc (S) ;
    p = psym (find (psym <= m)) ;
    q = psym (find (psym > m)) - m ;
    nb = length (rsym) - 1 ;
    comp = zeros (1,m+n) ;
    r = zeros (1,nb+1) ;
    s = zeros (1,nb+1) ;
    krow = 1 ;
    kcol = 1 ;
    for k = 1:nb
	% find the rows and columns in the kth component
	r (k) = krow ;
	s (k) = kcol ;
	ksym = psym (rsym (k):rsym (k+1)-1) ;
	krow = krow + length (find (ksym <= m)) ;
	kcol = kcol + length (find (ksym >  m)) ;
    end
    r (nb+1) = m+1 ;
    s (nb+1) = n+1 ;

else

    % find the strongly connected components of A
    [p,r] = cs_scc (A) ;
    q = p ;
    s = r ;

end

