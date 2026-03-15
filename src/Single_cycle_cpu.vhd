library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.isa_riscv.ALL;

entity single_cycle_cpu is
    port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        imem_load_en   : in  std_logic := '0';
        imem_load_addr : in  std_logic_vector(6 downto 0) := (others => '0');
        imem_load_data : in  std_logic_vector(31 downto 0) := (others => '0');
        current_pc     : out std_logic_vector(31 downto 0);
        current_instr  : out std_logic_vector(31 downto 0);
        alu_debug      : out std_logic_vector(31 downto 0);
        wb_debug       : out std_logic_vector(31 downto 0)
    );
end single_cycle_cpu;


architecture Behavioral of single_cycle_cpu is
    signal pc_value        : signed(31 downto 0);
    signal pc_target       : signed(31 downto 0);
    signal pc_plus4        : signed(31 downto 0);
    signal branch_target   : signed(31 downto 0);
    signal jump_target     : signed(31 downto 0);
    signal load_pc         : std_logic;

    signal instruction     : std_logic_vector(31 downto 0);
    signal immediate       : std_logic_vector(31 downto 0);
    signal rs1_data        : std_logic_vector(31 downto 0);
    signal rs2_data        : std_logic_vector(31 downto 0);
    signal alu_b           : std_logic_vector(31 downto 0);
    signal alu_result      : std_logic_vector(31 downto 0);
    signal mem_read_data   : std_logic_vector(31 downto 0);
    signal write_back_data : std_logic_vector(31 downto 0);
    signal alu_zero        : std_logic;
    signal alu_ltzero      : std_logic;

    signal reg_write       : std_logic;
    signal mem_write       : std_logic;
    signal mem_read        : std_logic;
    signal alu_src         : std_logic;
    signal branch          : std_logic;
    signal jump            : std_logic;
    signal branch_taken    : std_logic;
    signal wb_sel          : std_logic_vector(1 downto 0);
    signal alu_op          : std_logic_vector(3 downto 0);

begin
    pc_plus4      <= pc_value + 4;
    branch_target <= pc_value + signed(immediate);
    jump_target   <= pc_value + signed(immediate);

    pc_inst : entity work.program_counter
        generic map(bits => 32)
        port map(
            clk    => clk,
            rst    => rst,
            load   => load_pc,
            pc_in  => pc_target,
            pc_out => pc_value
        );

      instr_mem : entity work.memory_block
        generic map(mem_size => 128, addr_size => 7, word_size => 32)
        port map(
            clk       => clk,
            addrwrite => imem_load_addr,
            datawrite => imem_load_data,
            write_en  => imem_load_en,
            addread   => imem_load_addr when imem_load_en = '1' else std_logic_vector(pc_value(8 downto 2)),
            read_en   => '1',
            dataread  => instruction
        );


    data_mem : entity work.memory_block
        generic map(mem_size => 128, addr_size => 7, word_size => 32)
        port map(
            clk       => clk,
            addrwrite => alu_result(8 downto 2),
            datawrite => rs2_data,
            write_en  => mem_write,
            addread   => alu_result(8 downto 2),
            read_en   => mem_read,
            dataread  => mem_read_data
        );

    reg_file : entity work.register_file
        generic map(word_size => 32, size => 32)
        port map(
            clk    => clk,
            w_en   => reg_write,
            addr_a => instruction(19 downto 15),
            addr_b => instruction(24 downto 20),
            addr_c => instruction(11 downto 7),
            data_a => rs1_data,
            data_b => rs2_data,
            data_c => write_back_data
        );

    imm_gen_inst : entity work.imm_gen
        port map(
            instr => instruction,
            imm   => immediate
        );

    control_inst : entity work.control_unit
        port map(
            opcode     => instruction(6 downto 0),
            funct3     => instruction(14 downto 12),
            funct7_bit => instruction(30),
            reg_write  => reg_write,
            mem_write  => mem_write,
            mem_read   => mem_read,
            alu_src    => alu_src,
            branch     => branch,
            jump       => jump,
            wb_sel     => wb_sel,
            alu_op     => alu_op
        );

    alu_b <= immediate when alu_src = '1' else rs2_data;

    alu_inst : entity work.alu
        generic map(bits => 32)
        port map(
            a        => rs1_data,
            b        => alu_b,
            op       => alu_op,
            c        => alu_result,
            f_zero   => alu_zero,
            f_ltzero => alu_ltzero
        );

    process(instruction, branch, jump, rs1_data, rs2_data)
    begin
        branch_taken <= '0';

        if branch = '1' then
            case instruction(14 downto 12) is
                when func_BEQ =>
                    if rs1_data = rs2_data then
                        branch_taken <= '1';
                    end if;
                when func_BNE =>
                    if rs1_data /= rs2_data then
                        branch_taken <= '1';
                    end if;
                when func_BLT =>
                    if signed(rs1_data) < signed(rs2_data) then
                        branch_taken <= '1';
                    end if;
                when func_BGE =>
                    if signed(rs1_data) >= signed(rs2_data) then
                        branch_taken <= '1';
                    end if;
                when func_BLTU =>
                    if unsigned(rs1_data) < unsigned(rs2_data) then
                        branch_taken <= '1';
                    end if;
                when func_BGEU =>
                    if unsigned(rs1_data) >= unsigned(rs2_data) then
                        branch_taken <= '1';
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;

    load_pc   <= jump or branch_taken;
    pc_target <= jump_target when jump = '1' else branch_target;

    with wb_sel select
        write_back_data <= alu_result                 when "00",
                           mem_read_data              when "01",
                           std_logic_vector(pc_plus4) when "10",
                           immediate                  when others;

    current_pc    <= std_logic_vector(pc_value);
    current_instr <= instruction;
    alu_debug     <= alu_result;
    wb_debug      <= write_back_data;

end Behavioral;
