
uppercase.bin:     file format elf32-littleriscv


Disassembly of section .text:

00010074 <_start>:
   10074:	ffff2517          	auipc	a0,0xffff2
   10078:	f8c50513          	addi	a0,a0,-116 # 2000 <__DATA_BEGIN__>
   1007c:	00000793          	li	a5,0

00010080 <loop>:
   10080:	00050583          	lb	a1,0(a0)
   10084:	02f58c63          	beq	a1,a5,100bc <end_program>
   10088:	010000ef          	jal	ra,10098 <check_char>
   1008c:	00b50023          	sb	a1,0(a0)
   10090:	00150513          	addi	a0,a0,1
   10094:	fedff06f          	j	10080 <loop>

00010098 <check_char>:
   10098:	02000613          	li	a2,32
   1009c:	06100693          	li	a3,97
   100a0:	07b00713          	li	a4,123
   100a4:	00d5c863          	blt	a1,a3,100b4 <ignore>
   100a8:	00e5d663          	bge	a1,a4,100b4 <ignore>
   100ac:	fe058593          	addi	a1,a1,-32
   100b0:	0080006f          	j	100b8 <ret_check_char>

000100b4 <ignore>:
   100b4:	0040006f          	j	100b8 <ret_check_char>

000100b8 <ret_check_char>:
   100b8:	00008067          	ret

000100bc <end_program>:
   100bc:	0000006f          	j	100bc <end_program>
