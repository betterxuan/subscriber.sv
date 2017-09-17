

`ifndef HKY_REGS_CONTAINER_SV
`define HKY_REGS_CONTAINER_SV

class hky_regs_container extends uvm_object;

  string reg_map [int] ;
  hky_mem_range_t mem_map [string];
  local static hky_regs_container inst;

  `uvm_object_utils(hky_regs_container)

  function new (string name = "hky_regs_container");
    super.new(name);

    mem_map["lmu_ram0"].start_addr = 'h0000_0000;
    mem_map["lmu_ram0"].end_addr = 'h0002_DFFF;

    reg_map [32'hFF800880] = "HWaDlpdbIdpaIccChCreditsReceived"; 
    reg_map [32'hFF800884] = "HWaDlpdbIdpaIccChCreditsObserved"; 
  endfunction

  function string get_reg_name_by_addr(int addr);
    string mem_id;

    if(this.reg_map.exists(addr)) begin
      return this.reg_map[addr];
    end

    if(this.mem_map.first(mem_id)) begin
      do begin
        if(addr >= this.mem_map[mem_id].start_addr && addr <= this.mem_map[mem_id].end_addr)
          return mem_id;
      end while(this.mem_map.next(mem_id));
    end

    return "";
  endfunction

  static function hky_regs_container get_regs_container();
		if(inst==null)
			inst=new;
		return inst;
	endfunction 

endclass


`endif
