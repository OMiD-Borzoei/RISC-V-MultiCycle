module controller(input  logic       clk,
                  input  logic       reset,  
                  input  logic [6:0] op,
                  input  logic [2:0] funct3,
                  input  logic       funct7b5,
                  input  logic       Zero, Sign,

                  output logic [3:0] ImmSrc,
                  output logic [1:0] ALUSrcA, ALUSrcB,
                  output logic [1:0] ResultSrc, 
                  output logic  AdrSrc, 
                  output logic [3:0] ALUControl,
                  output logic       IRWrite, PCWrite, 
                  output logic       RegWrite, MemWrite, RegSrc, ImmIn,
		  output logic [1:0] MemMode
		  //output logic  [1:0] opb5func7b5
				);


	    logic [14:0] FSMControls;
		logic [1:0] ALUOp;
		logic PCUpdate, Branch;
		logic BrResult; 
			      
		assign {ALUOp, ALUSrcA, ALUSrcB, ResultSrc,
			AdrSrc, IRWrite, PCUpdate,
			RegWrite, MemWrite, Branch, ImmIn} = FSMControls ;

		assign PCWrite = BrResult | PCUpdate ;
				      //JALR		     //JAL
		assign RegSrc = op == 7'b1100111 ? 1 : op == 7'b1101111 ? 1 : 0;

		typedef enum logic[3:0]  {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9 ,S10, S11, S12} States ;
		States now, next ;

		always_ff @(posedge clk, posedge reset) begin
			if(reset) now <= S0;
			else      now <= next ;
		end
		
		always_comb begin 
				case(now)	// Current State				
					S0: begin 
						next = S1 ;  // Decode
						//Op, SrcA, B, Res, Adr, IR, PCU, Reg, Mem, Br, ImmIn
					    	FSMControls = 15'b00_00_10_10_0_1_1_0_0_0_0;
					end
					
					S1: begin 
						case(op)
							7'b1100011: next = S10 ; //BEQ
							7'b1101111: next = S9 ; //JAL
							7'b0010011: next = S8; //ExecuteI
							7'b0110011: next = S6; //ExecuteR
							7'b0000011: next = S2; //MemAdr
							7'b0100011: next = S2;  //MemAdr
							7'b1100111: next = S11; //LinkReg
							7'b0110111: next = S12; //LUI
							7'b0010111: next = S7; //auipc
							default:    next = S1; //MemAdr
						endcase
						//FSMControls = 15'b00_01_01_xx_x_0_0_0_0_0_0;
						  FSMControls = 15'b00_01_01_00_0_0_0_0_0_0_0;
					end

					S2: begin
						case(op)
							7'b0000011: next = S3; //MemRead	
							7'b0100011: next = S5; //MemWrite
							default:    next = S2;
						endcase	
						//FSMControls = 15'b00_10_01_xx_x_0_0_0_0_0_0;
						  FSMControls = 15'b00_10_01_00_0_0_0_0_0_0_0;
					end

					
					S3: begin 
						next = S4; //MemWB
					     	//FSMControls = 15'bxx_xx_xx_00_1_0_0_0_0_0_0;
						  FSMControls = 15'b00_00_00_00_1_0_0_0_0_0_0;
					end

					S4: begin 
						next = S0; //Fetch
						//FSMControls = 15'bxx_xx_xx_01_x_0_0_1_0_0_0;
						  FSMControls = 15'b00_00_00_01_0_0_0_1_0_0_1;
					end

					S5: begin 
						next = S0; //Fetch
						//FSMControls = 15'bxx_xx_xx_00_1_0_0_0_1_0_0;
						  FSMControls = 15'b00_00_00_00_1_0_0_0_1_0_0;
					end

					S6: begin
						next = S7; //ALUWB
						//FSMControls = 15'b10_10_00_xx_x_0_0_0_0_0_0;
						  FSMControls = 15'b10_10_00_00_0_0_0_0_0_0_0;
					end
					
					S7: begin
						next = S0; //Fetch
						//FSMControls = 15'bxx_xx_xx_00_x_0_0_1_0_0_0;
						  FSMControls = 15'b00_00_00_00_0_0_0_1_0_0_0;
					end

					S8: begin
						next = S7;
						//FSMControls = 14'b10_10_01_xx_x_0_0_0_0_0_0;
						  FSMControls = 15'b10_10_01_00_0_0_0_0_0_0_0;
					end

					S9: begin
						next = S0;
						//FSMControls = 14'b00_01_10_00_x_0_1_0_0_0;
						//FSMControls = 14'b00_01_10_00_0_0_1_0_0_0;
						//New JAL with 3 Cycles:
						//FSMControls = 14'bxx_xx_xx_00_x_x_1_1_x_x_0;
						  FSMControls = 15'b00_00_00_00_0_0_1_1_0_0_0;   
					end

					S10: begin
						next = S0;
						//FSMControls = 14'b01_10_00_00_x_0_0_0_0_1_0;
						  FSMControls = 15'b01_10_00_00_0_0_0_0_0_1_0;
					end 
					
					S11: begin
						next = S0;
					      //FSMControls = 14'b00_10_01_10_x_0_1_1_0_0_0;
						FSMControls = 15'b00_10_01_10_0_0_1_1_0_0_0; 
					end
				
					S12: begin
						next = S0;
					      //FSMControls = 14'bxx_xx_01_11_x_0_0_1_0_0_0;
					  	FSMControls = 15'b00_00_01_11_0_0_0_1_0_0_0;
					end
				endcase

		end


		logic [1:0] opb5func7b5;
		assign opb5func7b5 = {op[5], funct7b5} ;

		//ALU Decoder:
		always @(ALUOp, funct3, opb5func7b5, funct7b5) begin 
			case(ALUOp)
				2'b00: ALUControl = 4'b0000; //ADD
				2'b01: if(funct3 == 3'b110 || funct3 == 3'b111)//bltu || bgeu
						ALUControl = 4'b1011; //Unsinged Comparison
				       else	ALUControl = 4'b0001; //Signed Comparison
						 
				2'b10: case(funct3)	    // R-type, I-type	
					3'b000: begin
							if(opb5func7b5 == 2'b11)
						/*SUB*/		ALUControl = 4'b0001;
							else
						/*ADD*/		ALUControl = 4'b0000;
						end
					3'b010: ALUControl = 4'b0101; //slt
					3'b011: ALUControl = 4'b1010; //sltu
					3'b110: ALUControl = 4'b0011; //or
					3'b111: ALUControl = 4'b0010; //and
					3'b100: ALUControl = 4'b0100; //xor
					3'b001: ALUControl = 4'b0110; //SLL
					3'b101: ALUControl = funct7b5 ? 
					/*SRA*/	4'b1001 : 4'b1000 /*SRL*/ ;  
					endcase
			endcase
		end

		//Instruction Decoder
		always @(op, funct3, ImmIn) begin
		  case(op)
			7'b0000011: if(ImmIn)
					case(funct3)
					3'b000 : ImmSrc = 4'b1001; //lb
					3'b001 : ImmSrc = 4'b1000; //lh
					3'b100 : ImmSrc = 4'b0111; //lbu
					3'b101 : ImmSrc = 4'b0110; //lhu
					default: ImmSrc = 4'b1111; //lw
				      endcase
				    else	 ImmSrc = 4'b0000; //Address
			7'b0100011:   ImmSrc = 4'b0001;
			7'b0110011: //ImmSrc = 4'bxxxx;
			              ImmSrc = 4'b0000;
			7'b1100011:   ImmSrc = 4'b0010;
			7'b0010011: /*I-type*/   
				      begin
					if(funct3 == 4'b0001 || //SLLI
						funct3 == 4'b0101) //SRAI, SRLI
							ImmSrc = 4'b0100;
				        else 
							ImmSrc = 4'b0000; //Others
				      end
			7'b1101111:   ImmSrc = 4'b0011;
			7'b0110111:   ImmSrc = 4'b0101; //lui
			7'b0010111:   ImmSrc = 4'b0101; //auipc
			default   : //ImmSrc = 4'bxxxx;
			              ImmSrc = 4'b0000;
		  endcase
		end

		//Branch Decoder:
		always @(Branch, funct3, Zero, Sign)
			if(Branch)
			  case(funct3)
			/*BEQ*/3'b000: BrResult = Zero;
			/*BNE*/3'b001: BrResult = ~Zero;
			/*BLT*/3'b100: BrResult = Sign;
			/*BGE*/3'b101: BrResult = ~Sign;
		       /*BLTU*/3'b110: BrResult = Sign;
		       /*BGEU*/3'b111: BrResult = ~Sign;
			  endcase
			else BrResult = 0;
		
		always @(op, funct3)
			if(op==7'b0100011)  //Store
				if(funct3 == 3'b000) //sb
					MemMode = 2'b10;
				else if(funct3 == 3'b001) //sh
					MemMode = 2'b01;
				else MemMode = 2'b00; //sw
			else MemMode = 2'b00; //Non-Store	

endmodule