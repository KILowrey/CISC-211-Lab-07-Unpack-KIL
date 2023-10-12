/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global a_value,b_value
.type a_value,%gnu_unique_object
.type b_value,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
a_value:          .word     0  
b_value:           .word     0  

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/

    /* REGISTER TRACKER FOR PROGRAMMER
     * 
     * R0 - takes our input values
     * 
     * R1 - register for value A
     * R2 - register for value B
     * 
     * R3 - address for a_value
     * R4 - address for b_value
     * 
     * R6 - for our AND based Branch
     * 
     * R8 - stores 0x00008000
     * R9 - stores 0xFFFF0000
     * R10 - stores 0x0000FFFF
     */
    
    /* load R3 with the address for a_value
     * and R4 with the address for b_value 
     */
    LDR R3,=a_value
    LDR R4,=b_value
    
    /* we don't REALLY need to do these next 3 LDRs but I like the security */
    /* set R8 so that only bit 15 is set */
    LDR R8,=0x00008000
    /* set R9 so that the most significant 16 bits are all 1's */
    LDR R9,=0xFFFF0000
    /* set R10 to all 0s for the 16 MSBs and 1s for the 16 LSBs */
    LDR R10,=0x0000FFFF
    
    /* UNPACK OUR A VALUE */
    
    /* load R1 with 16 MSB of R0 */
    AND R1,R0,R9
    /* Arithmetic shift by 16 so that the packed 16 MSB are now the 16 LSB
     * and we extend the sign number across the 16 MSBs for negatives
     */
    ASR R1,R1,16
    
    /* UNPACK OUR B VALUE */
    
    /* use AND w/ our R10
     * so that we only load the 
     * 16 LSBs of R0 into R2 */
    AND R2,R0,R10
    
    /* AND w/ R2 and R6 
     * so that we can isolate the 15th bit 
     * which is the sign bit on the packed number */
    AND R6,R2,R8
    /* check if the 15th bit is set or not */
    CMP R6,R8
    /* IF the 15th bit (MSB in a 16 bit number) is 1
     * we ORR R2 & R9 so that 
     * the 16 MSBs are 1 so as to extend the former MSB */
    ORREQ R2,R2,R9
    
    /* store the unpacked a_value & b_value in their proper places */
    STR R1,[R3]
    STR R2,[R4]
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




