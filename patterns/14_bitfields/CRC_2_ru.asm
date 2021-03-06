_key$ = 8           ; size = 4
_len$ = 12          ; size = 4
_hash$ = 16         ; size = 4
_crc    PROC
    mov    edx, DWORD PTR _len$[esp-4]
    xor    ecx, ecx ; i ����� ������ � �������� ECX
    mov    eax, edx
    test   edx, edx
    jbe    SHORT $LN1@crc
    push   ebx
    push   esi
    mov    esi, DWORD PTR _key$[esp+4] ; ESI = key
    push   edi
$LL3@crc:

; �������� � ������� ��������� 32-������ ��������. � EDI ������� ���� � ������ key+i

    movzx  edi, BYTE PTR [ecx+esi]             
    mov    ebx, eax  ; EBX = (hash = len)
    and    ebx, 255  ; EBX = hash & 0xff


; XOR EDI, EBX (EDI=EDI^EBX) - ��� �������� ����������� ��� 32 ���� ������� ��������
; �� ��������� ���� (8-31) ����� �������� ������, ��� ��� ��� ��
; ��� �������� ������ ��� ��� EDI ��� ���� ������� ����������� MOVZX ����
; � ������� ���� EBX ���� �������� ����������� AND EBX, 255 (255 = 0xff)

    xor    edi, ebx                            
    
; EAX=EAX>>8; �������������� �� �������� ���� � ���������� (���� 24-31) ����� ��������� ������
    shr    eax, 8   

; EAX=EAX^crctab[EDI*4] - �������� ������� �� ������� crctab[] ��� ������� EDI
    xor    eax, DWORD PTR _crctab[edi*4] 
    inc    ecx            ; i++
    cmp    ecx, edx       ; i<len ?
    jb     SHORT $LL3@crc ; ��
    pop    edi
    pop    esi
    pop    ebx
$LN1@crc:
    ret    0
_crc    ENDP
