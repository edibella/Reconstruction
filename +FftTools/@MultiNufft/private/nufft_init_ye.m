 function st = nufft_init_ye(om, Nd, Jd, Kd, varargin)

% dimensionality of input space (usually 2 or 3)
dd = length(Nd);
%keyboard

if ~isempty(varargin) && isnumeric(varargin{1})
	n_shift = varargin{1};
	varargin = {varargin{2:end}};
else
	n_shift = zeros(size(Nd));
end

st.n_shift = n_shift;
st.alpha = {};
st.beta = {};

ktype = varargin{1};
st.ktype = ktype;

for id = 1:dd
    [st.kernel{id}, st.kb_alf(id), st.kb_m(id)] = kaiser_bessel('string', Jd(id));
end

st.tol	= 0;

st.Jd	= Jd;
st.Nd	= Nd;
st.Kd	= Kd;

M = size(om,1);
st.M	= M;
st.om	= om;

%
% scaling factors: "outer product" of 1D vectors
%
st.sn = 1;
for id=1:dd
    nc = (0:Nd(id)-1)'-(Nd(id)-1)/2;
	tmp = 1 ./ kaiser_bessel_ft(nc/Kd(id), Jd(id), st.kb_alf(id), st.kb_m(id), 1);
	st.sn = st.sn(:) * tmp';

	N = Nd(id);
	J = Jd(id);
	K = Kd(id);

    [c, arg] = nufft_coef(om(:,id), J, K, st.kernel{id});	% [J?,M]

	gam = 2*pi/K;
	phase_scale = 1i * gam * (N-1)/2;

	phase = exp(phase_scale * arg);	% [J?,M] linear phase
	ud{id} = phase .* c;		% [J?,M]

	%
	% indices into oversampled FFT components
	%
	koff = nufft_offset(om(:,id), J, K);	% [M,1] to leftmost near nbr
	%kd{id} = mod(outer_sum([1:J]', koff'), K) + 1;	% [J?,M] {1,...,K?}
    kd{id} = mod(bsxfun(@plus,(1:J)',koff'), K) + 1;
    % Ye EDIT 02/27/17
	if id > 1	% trick: pre-convert these indices into offsets!
		kd{id} = (kd{id}-1) * prod(Kd(1:(id-1)));
	end

end, clear c arg gam phase phase_scale koff N J K

%
% build sparse matrix that is [M,*Kd]
% with *Jd nonzero entries per frequency point
%

Jprod = prod(Jd);
kk = bsxfun(@plus,permute(kd{1},[1 3 2]),permute(kd{2},[3 1 2]));
kk = reshape(kk, Jprod, M);
uu = bsxfun(@times,permute(ud{1},[1 3 2]),permute(ud{2},[3 1 2]));
uu = reshape(uu, Jprod, M);

%
% apply phase shift
% pre-do Hermitian transpose of interpolation coefficients
%

phase = exp(1i * (om * n_shift(:))).';			% [1,M]
uu = conj(uu) .* phase(ones(1,prod(Jd)),:);		% [*Jd,M]

mm = 1:M; mm = mm(ones(prod(Jd),1),:);		% [*Jd,M]
st.p = sparse(mm(:), kk(:), uu(:), M, prod(Kd));	% sparse matrix
% sparse object, to better handle single precision operations!
st.p = Gsparse(st.p, 'odim', [M 1], 'idim', [prod(Kd) 1]);
