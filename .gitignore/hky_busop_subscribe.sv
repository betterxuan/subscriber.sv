


`ifndef HKY_BUSOP_SUBSCRIBER_SV
`define HKY_BUSOP_SUBSCRIBER_SV

`uvm_analysis_imp_decl(_axi)
`uvm_analysis_imp_decl(_ahb)

typedef class hky_regs_container;

class hky_busop_subscriber extends uvm_component;

  uvm_analysis_imp_axi #(svt_axi_transaction, hky_busop_subscriber) axi_analysis_export;
  //uvm_analysis_imp_axi #(uvm_tlm_generic_payload, hky_busop_subscriber) axi_analysis_export;
  uvm_analysis_imp_ahb #(svt_ahb_transaction, hky_busop_subscriber) ahb_analysis_export;

  hky_regs_container regs;
  `uvm_component_utils(hky_busop_subscriber)

  // Constructor
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    regs = hky_regs_container::get_regs_container();
    axi_analysis_export = new("axi_analysis_export", this);
    ahb_analysis_export = new("ahb_analysis_export", this);
  endfunction

  function void write_axi(svt_axi_transaction t);
    bit [hky_bus_addr_max_width_p-1:0] addr;
    bit [hky_bus_data_max_width_p-1:0] data[];
    int length;
    string reg_info; 
    string data_info;
    addr = t.addr;
    data = t.data;
    length = t.burst_length;

    reg_info = regs.get_reg_name_by_addr(addr);
    if(reg_info == "") 
      reg_info = "[UNMAPPED_ADDR]";

    foreach(data[i]) begin
      data_info = {data_info, $sformatf("data[%0d]=0x%0x  ",i, data[i])};
    end
    `uvm_info(get_name(), $sformatf("%s REG/MEM %s, ADDR = 0x%8x with data length = %0d",t.xact_type, reg_info, addr, length), UVM_LOW)
    `uvm_info(get_name(), $sformatf("%s", data_info), UVM_LOW)
  endfunction


  function void write_ahb(svt_ahb_transaction t);
    // TODO
    `uvm_info(get_name, "FUNCTION TO BE IMPLEMENTED", UVM_LOW)
  endfunction

endclass


`endif
