; #########################################################################
;
;  Irfan View 32 v3.0 Keymaker
;  Coded by Egis/CORE.
;
;  Only for educational purpose. I don't want to see anyone release a
;  new keymaker for Irfan View future versions based on this source.
;
;  Compiler: MASM v6.13
;  
; #########################################################################

      .386
      .model flat, stdcall
      option casemap : none

; #########################################################################

      include d:\masm32\include\windows.inc
      include d:\masm32\include\user32.inc
      include d:\masm32\include\kernel32.inc
      includelib d:\masm32\lib\user32.lib
      includelib d:\masm32\lib\kernel32.lib

; #########################################################################


    IDD_REGDIALOG   equ                101
    IDC_GETBUTTON   equ                1000
    IDC_NAMEEDIT    equ                1002
    IDC_CODEEDIT    equ                1003

;=============
; Local macros
;=============
  
szText MACRO Name, Text:VARARG
       LOCAL lbl
         jmp lbl
         Name db Text,0
         lbl:
       ENDM

;=================
; Local prototypes
;=================
RegWndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetRegNum  PROTO :DWORD

; It is hard to declare wsprintf in WINDOWS.INC
; for it demands variable parameters
EXTRN      wsprintfA: PROC

          
;=================
; Local prototypes
;=================
        
    .data

    DlgName     db      "REGDLG",0
    szFormat    db      "%lu", 0
    hInstance   dd      0
    szName      db      40 dup (0)
    szReg       db      20 dup (0)

; #########################################################################

    .code
    
start:

        invoke GetModuleHandle, NULL
        mov hInstance, eax
        
        ; Call the dialog box stored in resource file
        invoke DialogBoxParam, hInstance, ADDR DlgName, 0, ADDR RegWndProc, 0
        invoke ExitProcess, eax

; #########################################################################

RegWndProc proc hWin: DWORD, uMsg: DWORD, wParam: DWORD, lParam: DWORD
     LOCAL   hWnd

    .if uMsg == WM_SHOWWINDOW
        invoke GetDlgItem, hWin, IDC_NAMEEDIT
        invoke SetFocus, eax
    .elseif uMsg == WM_CLOSE
        invoke EndDialog, hWin, 0
    .elseif uMsg == WM_COMMAND
        jmp     WMCOMMAND
    .endif
        jmp     return

WMCOMMAND:
    mov     eax, wParam
    cmp     ax, IDC_GETBUTTON
    jnz     return
    invoke GetRegNum, hWin

return:

    ret

RegWndProc endp

; #########################################################################

GetRegNum proc hDlg: DWORD

    invoke GetDlgItemTextA, hDlg, IDC_NAMEEDIT, ADDR szName, 40
    
    lea     esi, szName
    cmp     byte ptr [esi], 0
    jnz     @1

    szText  szErrName, "Invalid registration name.", 0
    szText  szErr, "Error", 0
    invoke MessageBoxA, 0, ADDR szErrName, ADDR szErr, MB_OK

@1:
    xor     eax, eax
    xor     ecx, ecx
@2:    
    lodsb
    test    al, al
    jz      @3
    add     ecx, eax
    jmp     @2
@3:
    mov     ebx, 260
    sub     ebx, ecx
    cmp     ebx, 7fffffffh
    jb      @5
    neg     ebx
@4:
    add     ebx, 332
    imul    ebx, 472

    ; Cannot use INVOKE macro here   :(
    push    ebx
    push    offset szFormat
    push    offset szReg
    call    wsprintfA
    ; And you must reset stack pointer yourself
    add     esp, 4*3

    cmp     ebx, 1000000
    jge     @5
    
    xor     eax, eax
    xor     ebx, ebx
    xor     ecx, ecx
    xor     edx, edx
    mov     cl, byte ptr [4+szReg]
    mov     al, byte ptr [5+szReg]
    mov     dl, byte ptr [3+szReg]
    mov     6+szReg, cl
    mov     cl,byte ptr [1+szReg]
    mov     8+szReg, al
    mov     al,byte ptr [2+szReg]
    mov     2+szReg, cl
    mov     cl,byte ptr [8+szReg]
    mov     3+szReg, al
    mov     5+szReg, dl
    mov     dl,byte ptr [4+szReg]
    lea     eax, [ecx+ecx*4]
    and     edx, 0ffh
    shl     eax, 3
    sub     eax, ecx
    mov     ecx, edx
    shl     ecx, 5
    sub     ecx, edx
    lea     edx, [ecx+ecx*2]
    sub     eax, edx
    cdq
    mov     ecx, eax
    xor     ecx, edx
    sub     ecx, edx
    lea     eax, [ecx+ecx*4]
    shl     eax, 3
    sub     eax, ecx
    mov     ecx, 9
    cdq
    idiv    ecx
    mov     al, byte ptr [3+szReg]
    and     eax, 0ffh
    add     edx, 30h
    mov     szReg+7, dl
    lea     edx, [eax+eax*2]
    shl     edx, 4
    sub     edx, eax
    mov     al, byte ptr [5+szReg]
    and     eax, 0ffh
    lea     ecx, [eax+eax*8]
    lea     eax, [eax+ecx*4]
    lea     eax, [edx+eax*2]
    cdq
    xor     eax, edx
    sub     eax, edx
    lea     ecx, [eax+eax*8]
    lea     eax, [eax+ecx*4]
    mov     ecx, 9
    shl     eax, 1
    cdq
    idiv    ecx
    mov     cl, byte ptr [szReg]
    and     ecx, 0ffh
    lea     eax, [ecx+ecx*2]
    lea     eax, [eax+eax*8]
    shl     eax, 1
    sub     eax, ecx
    add     edx, 30h
    mov     szReg+4, dl
    mov     dl, byte ptr [1+szReg]
    and     edx, 0ffh
    mov     ecx, edx
    shl     ecx, 3
    sub     ecx, edx
    lea     edx, [ecx+ecx*4]
    sub     eax, edx
    cdq
    mov     ecx, eax
    xor     ecx, edx
    sub     ecx, edx
    lea     eax, [ecx+ecx*2]
    lea     eax, [eax+eax*8]
    shl     eax, 1
    sub     eax, ecx
    cdq
    mov     ecx, 9
    idiv    ecx
    add     dl,30h
    mov     szReg+1, dl
    mov     szReg+9, 0
    jmp     @print 

@5:
    xor     eax, eax
    xor     ebx, ebx
    xor     ecx, ecx
    xor     edx, edx
    mov     al, byte ptr [5+szReg]
    mov     dl, byte ptr [6+szReg]
    mov     cl, byte ptr [4+szReg]
    mov     szReg+6, al
    mov     al, byte ptr [1+szReg]
    mov     szReg+8, dl
    mov     dl, byte ptr [2+szReg]
    mov     szReg+5, cl
    mov     cl, byte ptr [6+szReg]
    mov     szReg+2, al
    mov     al, byte ptr [8+szReg]
    mov     szReg+3, dl
    mov     edx, ecx
    lea     eax, [eax+eax*8]
    shl     edx, 6
    shl     eax, 2
    sub     edx, ecx
    mov     ecx, 9
    sub     eax, edx
    cdq
    xor     eax, edx
    sub     eax, edx
    lea     eax, [eax+eax*8]
    shl     eax, 2
    cdq
    idiv    ecx
    mov     al, byte ptr [3+szReg]
    and     eax, 0ffh
    add     edx, 30h
    mov     szReg+7,dl
    lea     edx, [eax+eax*4]
    shl     edx, 3
    sub     edx, eax
    mov     al, byte ptr [4+szReg]
    and     eax, 0ffh
    add     eax, 20h
    mov     ecx, eax
    shl     ecx, 3
    sub     ecx, eax
    lea     eax, [eax+ecx*4]
    lea     eax, [eax+eax*2]
    lea     eax, [eax+edx*2]
    cdq
    xor     eax, edx
    sub     eax, edx
    mov     ecx, eax
    shl     ecx, 3
    sub     ecx, eax
    lea     eax, [eax+ecx*4]
    mov     ecx, 9
    lea     eax, [eax+eax*2]
    cdq
    idiv    ecx
    mov     al, byte ptr [szReg]
    and     eax, 0ffh
    add     dl, 30h
    mov     szReg+4, dl
    mov     edx, eax
    shl     edx, 3
    sub     edx, eax
    lea     eax, [eax+edx*4]
    mov     dl, byte ptr [1+szReg]
    and     edx, 0ffh
    mov     ecx, edx
    shl     ecx, 4
    add     ecx, edx
    shl     eax, 1
    lea     ecx, [ecx+ecx*4]
    sub     eax, ecx
    cdq
    xor     eax, edx
    sub     eax, edx
    mov     edx, eax
    shl     edx, 3
    sub     edx, eax
    lea     eax, [eax+edx*4]
    shl     eax, 1
    cdq
    mov     ecx, 9
    idiv    ecx
    add     dl, 30h
    mov     szReg+1, dl
    mov     szReg+9, 0

@print:
    invoke SetDlgItemTextA, hDlg, IDC_CODEEDIT, ADDR szReg

    ret
    
GetRegNum   endp

; #########################################################################

    end start

; #########################################################################
   