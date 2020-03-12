//////////////////////////////////////////////////
//File    : udp_parser_new.v
//Module  : udp_parser_new.v
//Author  : xjy
//Func    : 
//Create  : 2018/3/15
//Version : 0.0.0.2
//////////////////////////////////////////////////


module udp_parser_new(
input  wire clk,
input  wire rst,

//Input AXI Stream Interface
input  wire [63   : 0]    data_slave,
input  wire [7    : 0]    keep_slave,
input  wire [0    : 0]    valid_slave,
input  wire [0    : 0]    last_slave,
output wire [0    : 0]    ready_slave,

//Output AXI Stream Interface
output wire [63   : 0]    data_master,
output wire [7    : 0]    keep_master,
output wire [0    : 0]    valid_master,
output wire [0    : 0]    last_master,
input  wire [0    : 0]    ready_master,

//filter message according to udp port
input wire  [15   : 0]    local_udp_port,

input wire  [47   : 0]    mac_src_address_in,
input wire  [47   : 0]    mac_dst_address_in,
input wire  [15   : 0]    mac_type_in,
input wire  [3    : 0]    ip_version_in,
input wire  [3    : 0]    ip_header_length_in,
input wire  [7    : 0]    ip_service_in,
input wire  [15   : 0]    ip_total_length_in,
input wire  [15   : 0]    ip_identification_in,
input wire  [2    : 0]    ip_flag_in,
input wire  [12   : 0]    ip_offset_in,
input wire  [7    : 0]    ip_lifetime_in,
input wire  [7    : 0]    ip_protocol_in,
input wire  [15   : 0]    ip_checksum_in,
input wire  [31   : 0]    ip_src_address_in,
input wire  [31   : 0]    ip_dst_address_in,

//Output results
output reg  [47   : 0]    mac_src_address,
output reg  [47   : 0]    mac_dst_address,
output reg  [15   : 0]    mac_type,
output reg  [3    : 0]    ip_version,
output reg  [3    : 0]    ip_header_length,
output reg  [7    : 0]    ip_service,
output reg  [15   : 0]    ip_total_length,
output reg  [15   : 0]    ip_identification,
output reg  [2    : 0]    ip_flag,
output reg  [12   : 0]    ip_offset,
output reg  [7    : 0]    ip_lifetime,
output reg  [7    : 0]    ip_protocol,
output reg  [15   : 0]    ip_checksum,
output reg  [31   : 0]    ip_src_address,
output reg  [31   : 0]    ip_dst_address,
output reg  [15   : 0]    udp_src_port,
output reg  [15   : 0]    udp_dst_port,
output reg  [15   : 0]    udp_length,
output reg  [15   : 0]    udp_checksum
);

localparam IDLE = 4'b0001,
           HEAD = 4'b0010,
           DATA = 4'b0100,
           WAIT = 4'b1000;

reg [3:0] ps;
reg [3:0] ns;

wire is_idle;
wire is_head;
wire is_data;
wire is_wait; 

assign is_idle = (ps == IDLE);
assign is_head = (ps == HEAD);
assign is_data = (ps == DATA);
assign is_wait = (ps == WAIT);

wire [63  :0] data_out;
reg  [7   :0] keep_out;
wire [0   :0] valid_out;
wire [0   :0] last_out;
wire [0   :0] ready_out;

reg  [63  :0] data;
reg  [0   :0] valid;
reg  [0   :0] last;
reg  [63  :0] data_r;
reg  [15  :0] length;
reg  [5   :0] header;
wire [63  :0] rdata;

assign data_out = data[63:0];

assign valid_out = (((is_data & valid) | last) & (udp_dst_port == local_udp_port));
assign last_out  = (length <= 'd8  ) & valid_out;
assign ready_slave = ready_out & ~last;


assign data_master  = data_out;
assign valid_master = valid_out;
assign keep_master  = keep_out;
assign last_master  = last_out;
assign ready_out    = ready_master;
always @ (*)
begin 
    keep_out = 0;
    case (length)
        'd7  : keep_out =   8'h7f;
        'd6  : keep_out =   8'h3f;
        'd5  : keep_out =   8'h1f;
        'd4  : keep_out =   8'h0f;
        'd3  : keep_out =   8'h07;
        'd2  : keep_out =   8'h03;
        'd1  : keep_out =   8'h01;
        'd0  : keep_out =   8'h00;
        default: keep_out =   8'hff;
    endcase
end

assign rdata = {
data[7   :   0],
data[15  :   8],
data[23  :  16],
data[31  :  24],
data[39  :  32],
data[47  :  40],
data[55  :  48],
data[63  :  56]
};

wire valid_ready;
assign valid_ready = (valid_slave & ready_slave) | (is_data & ~last_out);

wire true_last;
assign true_last = last_slave & valid_ready;

wire header_last;
assign header_last = (header == 'd0);

always @(posedge clk or posedge rst) 
begin
    if (rst) ps <= IDLE;
    else     ps <= ns;
end

always @ (*)
begin
    case (ps)
        IDLE:   if  (valid_ready)   ns = HEAD;
                else                ns = IDLE;
        HEAD:   if  (valid_ready & header_last)
                                    ns = DATA;
                else                ns = HEAD;
        DATA:   if (last_out & ready_master) 
                begin
                    if (last)       ns = IDLE;
                    else            ns = WAIT;
                end
                else                ns = DATA;
        WAIT:   if (true_last)      ns = IDLE;
                else                ns = WAIT;
        default:                    ns = IDLE;
    endcase
end

always @ (posedge clk)
begin 
    if (rst) begin 
        data <= 'b0;
        data_r <= 'b0;
    end
    else if (valid_ready) begin
        data <= data_slave;
        data_r <= data;
    end
    else begin
        data <= data;
        data_r <= data_r;
    end
end

always @ (posedge clk or posedge rst) 
begin
    if (rst)
        valid <= 'b0;
    else if (ready_master)
        valid <= valid_ready;
    else
        valid <= valid;
end

always @ (posedge clk or posedge rst)
begin
    if (rst)
        last <= 1'b0;
    else if (true_last)
        last <= 1'b1;
    else if (ns == IDLE)
        last <= 1'b0;
    else
        last <= last;
end

reg  [15   : 0]    udp_src_port_out;
reg  [15   : 0]    udp_dst_port_out;
reg  [15   : 0]    udp_length_out;
reg  [15   : 0]    udp_checksum_out;

always @ (posedge clk or posedge rst)
begin
    if (rst)
    begin
        mac_src_address <= 'd0;
        mac_dst_address <= 'd0;
        mac_type <= 'd0;
        ip_version <= 'd0;
        ip_header_length <= 'd0;
        ip_service <= 'd0;
        ip_total_length <= 'd0;
        ip_identification <= 'd0;
        ip_flag <= 'd0;
        ip_offset <= 'd0;
        ip_lifetime <= 'd0;
        ip_protocol <= 'd0;
        ip_checksum <= 'd0;
        ip_src_address <= 'd0;
        ip_dst_address <= 'd0;
        udp_src_port <= 'd0;
        udp_dst_port <= 'd0;
        udp_length <= 'd0;
        udp_checksum <= 'd0;
        udp_src_port_out <= 'd0;
        udp_dst_port_out <= 'd0;
        udp_length_out <= 'd0;
        udp_checksum_out <= 'd0;
    end
    else if (is_head)
        case (header)
            'd0   : 
            begin
                udp_src_port[15:0] <= rdata[63:48];
                udp_dst_port[15:0] <= rdata[47:32];
                udp_length[15:0] <= rdata[31:16] - 16'd8;
                udp_checksum[15:0] <= rdata[15:0];                
            end
        endcase
    else if(ip_protocol_in != 8'd17)
    begin
        mac_src_address <= 'd0;
        mac_dst_address <= 'd0;
        mac_type <= 'd0;
        ip_version <= 'd0;
        ip_header_length <= 'd0;
        ip_service <= 'd0;
        ip_total_length <= 'd0;
        ip_identification <= 'd0;
        ip_flag <= 'd0;
        ip_offset <= 'd0;
        ip_lifetime <= 'd0;
        ip_protocol <= 'd0;
        ip_checksum <= 'd0;
        ip_src_address <= 'd0;
        ip_dst_address <= 'd0;
        udp_src_port <= 'd0;
        udp_dst_port <= 'd0;
        udp_length <= 'd0;
        udp_checksum <= 'd0;
    end
    else
    begin
        mac_src_address <= mac_src_address_in;
        mac_dst_address <= mac_dst_address_in;
        mac_type <= mac_type_in;
        ip_version <= ip_version_in;
        ip_header_length <= ip_header_length_in;
        ip_service <= ip_service_in;
        ip_total_length <= ip_total_length_in;
        ip_identification <= ip_identification_in;
        ip_flag <= ip_flag_in;
        ip_offset <= ip_offset_in;
        ip_lifetime <= ip_lifetime_in;
        ip_protocol <= ip_protocol_in;
        ip_checksum <= ip_checksum_in;
        ip_src_address <= ip_src_address_in;
        ip_dst_address <= ip_dst_address_in;
        udp_src_port <= udp_src_port;
        udp_dst_port <= udp_dst_port;
        udp_length <= udp_length;
        udp_checksum <= udp_checksum;
    end       
end

always @ (posedge clk or posedge rst)
begin
    if (rst) 
        length <= 'd0;
    else if (is_head & (header == 'd0))
        length[15:0] <= rdata[31:16] - 16'd8;
    else if (valid_out & ready_master)
        length <= length - 'd8;
    else if (ns == IDLE) 
        length <= 'd0;
    else 
        length <= length;
end

always @(posedge clk or posedge rst) begin
    if (rst) 
        header <= 'd0;
    else if (~is_head)
        header <= 'd0;
    else if (valid_ready)
        header <= header + 'd1;
    else
        header <= header;
end

endmodule