classdef Fatrix
  properties
    caller
    arg
    dim
    is_transpose
    is_subref
    nblock
    iblock
    handle_back
    handle_forw
    handle_power
    handle_ufun
    handle_abs
    handle_free
    handle_gram
    handle_mtimes_block
    handle_block_setup
    handle_blockify_data
    cascade_after
    cascade_before
  end
  methods
    function obj = Fatrix(Struct)
      % create Fatrix from Struct via eval
      fields = fieldnames(Struct);
      nField = length(fields);
      for iField = 1:nField
        fieldname = fields{iField};
        command = strcat('obj.',fieldname,' = Struct.',fieldname,';');
        eval(command);
      end
    end
  end

  methods(Static)
    function st = create_fatrix_struct(dim, arg, varargin)
      %
      % create default object, as required by Mathworks
      %
      st.caller = '';
      st.arg = {};
      st.dim = [];
      st.is_transpose	= false;
      st.is_subref	= false;
      st.nblock	= [];
      st.iblock	= [];

      % trick: default to some simple inline functions, which will work if
      % "arg" is anything that knows how to multiply, e.g., a matrix.
      st.handle_back = inline('M'' * x', 'M', 'x');
      st.handle_forw = inline('M * x', 'M', 'x');
      st.handle_power = inline('M .^ p', 'M', 'p');

      st.handle_ufun = [];
      st.handle_abs = [];
      st.handle_free = [];
      st.handle_gram = [];
      st.handle_mtimes_block = [];
      st.handle_block_setup = [];
      st.handle_blockify_data = [];
      st.cascade_after = [];
      st.cascade_before = [];

      % Display help message if no arguments are passed in
      if nargin == 0
	       if nargout == 0, help(mfilename), end
	        st = class(st, 'Fatrix');
          return
      end

      % Fatrix needs at least dims and arg, two arguments
      if nargin < 2
	       help(mfilename)
	       error(mfilename)
      end

      st.arg = arg;
      st.dim = dim;

      % After that it can handle a large number of options
      st = FftTools.shared.vararg_pair(st, varargin, 'subs', { ...
	      'ufun', 'handle_ufun';
	      'abs', 'handle_abs';
	      'free', 'handle_free';
	      'back', 'handle_back';
	      'forw', 'handle_forw';
	      'gram', 'handle_gram';
	      'power', 'handle_power';
	      'block_setup', 'handle_block_setup';
	      'blockify_data', 'handle_blockify_data';
	      'mtimes_block', 'handle_mtimes_block'});

    end
  end %methods
end %classdef
