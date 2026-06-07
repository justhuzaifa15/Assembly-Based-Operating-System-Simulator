include emu8086.inc
.model small
.stack 100h
.data 
menu db 13,10,"===== MINI OS SIMULATOR =====",13,10
     db "1. Create Process",13,10
     db "2. Display Process Table",13,10
     db "3. Search Process",13,10 
     db "4. Delete Process",13,10   
     db "5. FCFS Scheduling",13,10  
     db "6. SJF Scheduling",13,10
     db "7. Priority Scheduling",13,10
     db "8. Memory Report",13,10
     db "9. System Statistics",13,10
     db "0. Exit",13,10
     db "Enter Choice:$"  
     
tabletitle db 13,10,"===== PROCESS TABLE =====$"
tableHeader db 13,10,"PID   BURST   PRIORITY   MEMORY$"    
fcfsheader db 13,10,"===== FCFS SCHEDULING =====$"  
fcfscolumns db 13,10,"PID   BURST$"        
sjfheader db 13,10,"===== SJF SCHEDULING =====$"    
priorityheader db 13,10,"===== PRIORITY SCHEDULING =====$" 
prioritycolumns db 13,10,"PID   PRIORITY$"
processcount db 0   
npid db 1
searchPID db ?
memoryheader db 13,10,"===== MEMORY REPORT =====$"
memorycolumns db 13,10,"PID   MEMORY$"
totalMemory db 0
minBurst db ?
minIndex db ?
minpriority db ?
processIDs db 10 dup(?)
bursttime  db 10 dup(?)
priority   db 10 dup(?)
memoryreq db 10 dup(?) 
totalmemorymsg db 13,10,"Total Memory: $"                       
visited db 10 dup(0)
statsheader db 13,10,"===== SYSTEM STATISTICS =====$"
totalprocessmsg db 13,10,"Total Processes: $"
totalmemorymsg2 db 13,10,"Total Memory: $"
avgburstmsg db 13,10,"Average Burst Time: $"
highestprioritymsg db 13,10,"Highest Priority: $"
totalBurst db 0
avgBurst db 0
highestPriority db 99

         
.code 

main proc  
    mov ax,@data
    mov ds,ax
    start_menu:  
       
       
       lea dx,menu
       mov ah,09h
       int 21h
       
        mov ah,01h
        int 21h             
                
        sub al,30h 
        
        
        printn ""      
        cmp al,1
        je option1
        
        cmp al,2
        je option2
        
        cmp al,3
        je option3
        
        cmp al,4
        je option4
        
        cmp al,5          
        je option5
        
        cmp al,6
        je option6  
        
        cmp al,7
        je option7
        
        cmp al,8
        je option8
        
        cmp al,9
        je option9
        
        cmp al,0
        je exit_program
        
        printn "Invalid Choice"
        jmp start_menu 
    
         
       
    
    
    option1:
        call create_process 
        jmp start_menu
        
        

    option2:
        call display_process_table
        jmp start_menu
    
    option3:
        call search_process
        jmp start_menu
    
    
    option4:
        call delete_process
        jmp start_menu
    
    option5:
        call fcfs_scheduling 
        jmp start_menu
           
    option6:
        call sjf_scheduling
        jmp start_menu

    option7: 
        call priority_scheduling
        jmp start_menu

    option8:
        call memory_report
        jmp start_menu
    
    option9:   
        call system_statistics  
        jmp start_menu

                      
    exit_program: 
        printn "Exiting Program........."
        mov ah,4ch
        int 21h 
        
    main endp   
        
        
        
    
    create_process proc  
        
        cmp processcount,10
        JE create_limit_reached        
        
        mov ah,0
        mov al,processcount
        mov si,ax
        
        mov cl,npid
        mov processIDs[si],cl 
       
        print "Enter Burst Time:" 
        
        mov ah,01h
        int 21h 
        
        sub al,30h       
        
        mov bursttime[si],al   
        printn " "
        
        print "Enter priority:"
        
        mov ah,01h
        int 21h
        
        sub al,30h
        
        mov priority[si],al  
        printn " "  
        
        print "Enter Memory Requirements:"
        mov ah,01h
        int 21h
        
        sub al,30h
        
        mov memoryreq[si],al 
        printn " "   
        
        inc processcount
        inc npid
        
        printn "Process Created Successfully" 
        ret
       
        
        
        
        
        create_limit_reached:
        printn "Maximum Process Count Reached...."

        ret
        
    create_process endp
    
    
    display_process_table proc
        cmp processcount,0
        JE display_empty  
        
        lea dx,tabletitle
        mov ah,09h
        int 21h  
        
        printn ""
        
        lea dx,tableHeader 
        mov ah,09h
        int 21h   
        printn ""
        mov si,0 
        display_data:
        
        mov dl,processIDs[si] 
        add dl,30h
        mov ah,02h
        int 21h
        print "       "
                      
        mov dl,bursttime[si] 
        add dl,30h
        mov ah,02h
        int 21h
        print "         "        
        mov dl,priority[si] 
        add dl,30h
        mov ah,02h
        int 21h   
        print "         "
        mov dl,Memoryreq[si] 
        add dl,30h
        mov ah,02h
        int 21h   
        printn ""
                
                
        inc si 
        mov ax,si 
        
        cmp al,processcount 
        JL display_data  
        ret
                
        display_empty:
        printn "No Process Found"
        ret
    
        
     display_process_table endp   
    
    
    
    search_process proc
        cmp processcount,0
        Je search_empty  
        
        print "Enter PID To Search:"
        mov ah,01h
        int 21h
        
        sub al,30h
        
        mov searchPID,al   
        
        mov si,0
        search_loop:
        mov al,processIDs[si]
        cmp al,searchPID
        je search_found
        
        
        inc si        
        mov ax,si
        
        cmp al,processcount
        jl search_loop
        
        printn "Process Not Found"
        ret
         
        search_found: 
        lea dx,tabletitle
        mov ah,09h
        int 21h  
        
        printn ""
        
        lea dx,tableHeader 
        mov ah,09h
        int 21h   
        printn ""
        
        mov dl,processIDs[si] 
        add dl,30h
        mov ah,02h
        int 21h
        print "       "
                      
        mov dl,bursttime[si] 
        add dl,30h
        mov ah,02h
        int 21h
        print "         "        
        mov dl,priority[si] 
        add dl,30h
        mov ah,02h
        int 21h   
        print "         "
        mov dl,Memoryreq[si] 
        add dl,30h
        mov ah,02h
        int 21h   
        printn ""
        
        ret
        
        
        search_empty:
        printn "No Process Found"
        
        ret
            
        search_process endp
    
    
    
    delete_process proc
        cmp processcount,0
        Je delete_empty   
        
        print "Enter PID to Delete:"   
        mov ah,01h
        int 21h
        sub al,30h
        
        mov searchPID,al
        mov si,0
        delete_search_loop:
        mov al,processIDs[si]
        cmp al,searchPID
        je delete_shift_loop
        
        
        inc si        
        mov ax,si
        
        cmp al,processcount
        jl delete_search_loop
        
        printn "Process Not Found"
        ret
         
        delete_shift_loop:  
        mov ah,0
        mov al,processcount
        dec al

        cmp si,ax
        je delete_done
        
        mov al,processIDs[si+1]
        mov processIDs[si],al 
        
        mov al,bursttime[si+1]
        mov bursttime[si],al
        
        mov al,priority[si+1]
        mov priority[si],al
        
        mov al,memoryreq[si+1]
        mov memoryreq[si],al        
        
        inc si
        
        mov ah,0
        mov al,processcount
        dec al
        
        
        cmp si,ax
        jl delete_shift_loop
        
       delete_done:
         dec processcount
         printn " "
         printn "Process Deleted Successfully"
         ret

        delete_empty:
        printn " "
        printn "No Process Found"
        
        
        ret
        
        delete_process endp   
    
    fcfs_scheduling proc
        cmp processcount,0    
        JE fcfs_scheduling_empty  
        
        lea dx,fcfsheader
        mov ah,09h
        int 21h      
        printn " "
        lea dx,fcfscolumns
        mov ah,09h
        int 21h
        printn " "
        mov si,0
        fcfs_scheduling_loop:
        
        mov dl,processIDs[si]
        add dl,30h
        mov ah,02h
        int 21h
        print "       "
        
        mov dl,bursttime[si]
        add dl,30h
        mov ah,02h
        int 21h
        printn " "         
        inc si
        
        mov ax,si
        cmp al,processcount
        
        jl fcfs_scheduling_loop
        
        ret
        
 
        fcfs_scheduling_empty:
        printn " " 
        printn "No Process Found"
        ret
        
        fcfs_scheduling endp
    
    
    sjf_scheduling proc
        cmp processcount,0
        je sjf_scheduling_empty  
        
        mov si,0
        
        sjf_zero_loop:
        mov visited[si],0
        
        inc si
        mov ax,si
        cmp al,processcount     
        jl sjf_zero_loop
        
        lea dx,sjfheader
        mov ah,09h
        int 21h
        printn " "
        
        lea dx,fcfscolumns 
        mov ah,09h
        int 21h
        printn ""
        
        mov bl,0
        sjf_outerloop: 
        mov minBurst,99
        mov minindex,255
        
        mov si,0 
        
        sjf_find_min_loop:
        mov al,visited[si]
        cmp al,1
        je sjf_next_process
        
        
        mov al,bursttime[si]
        cmp al,minburst
        jge sjf_next_process  
        
        mov al,bursttime[si]                       
        mov minBurst,al   
        mov ax,si
        mov minIndex,al
        
        sjf_next_process:
        inc si
        
        
        mov ax,si
        cmp al,processcount
        jl sjf_find_min_loop
        
        
        mov si,0
        mov al,minIndex 
        mov ah,0
        mov si,ax
        
        printn ""
        mov dl,processIds[si]
        add dl,30h
        mov ah,02h
        int 21h
        print "      "
        
        mov dl,bursttime[si]
        add dl,30h
        mov ah,02h
        int 21h 
        printn ""
        
        mov visited[si],1
        
        inc bl
        cmp bl,processcount
        jl sjf_outerloop
        ret
        
        sjf_scheduling_empty:
        printn ""
        printn "No Process Found"
        ret
        
        sjf_scheduling endp
    
    
    
     priority_scheduling proc
        cmp processcount,0
        je priority_empty  
        
        mov si,0
        
        priority_loop:
        mov visited[si],0
        
        inc si
        mov ax,si
        cmp al,processcount     
        jl priority_loop
        
        lea dx,priorityheader
        mov ah,09h
        int 21h
        printn " "
        
        lea dx,prioritycolumns 
        mov ah,09h
        int 21h
        printn ""
        
        mov bl,0
        priority_outerloop: 
        mov minpriority,99
        mov minindex,255
        
        mov si,0 
        
        priority_find_min_loop:
        mov al,visited[si]
        cmp al,1
        je priority_next_process
        
        
        mov al,priority[si]
        cmp al,minpriority
        jge priority_next_process  
        
        mov al,priority[si]                       
        mov minpriority,al   
        mov ax,si
        mov minIndex,al
        
        priority_next_process:
        inc si
        
        
        mov ax,si
        cmp al,processcount
        jl priority_find_min_loop
        
        
        mov si,0
        mov al,minIndex 
        mov ah,0
        mov si,ax
        
        printn ""
        mov dl,processIds[si]
        add dl,30h
        mov ah,02h
        int 21h
        print "      "
        
        mov dl,priority[si]
        add dl,30h
        mov ah,02h
        int 21h 
        printn ""
        
        mov visited[si],1
        
        inc bl
        cmp bl,processcount
        jl priority_outerloop
        ret
        
        priority_empty:
        printn ""
        printn "No Process Found"
        ret
        
        
        priority_scheduling endp
     
     
     memory_report proc
        cmp processcount,0
        je memory_empty  
        mov si,0
        
        
        lea dx,memoryheader
        mov ah,09h
        int 21h
        printn ""
        lea dx,memorycolumns 
        mov ah,09h
        int 21h
        printn " "
        
        mov totalMemory,0
        
        memory_loop:
        mov dl,processIDs[si]
        add dl,30h
        mov ah,02h
        int 21h
        print "      "
        mov dl,memoryreq[si]
        add dl,30h
        mov ah,02h
        int 21h
        printn " " 

        mov al,totalMemory
        add al,memoryreq[si]
        mov totalMemory,al
        inc si
        
        mov ax,si
        cmp al,processcount
        jl memory_loop
        lea dx,totalmemorymsg2
        mov ah,09h
        int 21h
        
        mov al,totalMemory
        mov ah,0
        mov bl,10
        div bl
        
        
        
        mov bh,ah
        
        cmp al,0
        je memory_print_ones
        mov dl,al
        add dl,30h
        mov ah,02h
        int 21h
        
        mov dl,bh
        add dl,30h
        mov ah,02h
        int 21h   
        ret 
        
        memory_print_ones:
        mov dl,bh
        add dl,30h
        mov ah,02h
        int 21h
        ret
        
        
        
        memory_empty:
        printn ""
        printn "No Process Found"
                               
                               
        ret
        
        memory_report endp
     
     system_statistics proc
        cmp processcount,0
        je stats_empty
    
        lea dx,statsheader
        mov ah,09h
        int 21h
    
        mov totalMemory,0
        mov totalBurst,0
        mov highestPriority,99
    
        mov si,0
    
    stats_loop:
        mov al,totalMemory
        add al,memoryreq[si]
        mov totalMemory,al
    
        mov al,totalBurst
        add al,bursttime[si]
        mov totalBurst,al
    
        mov al,priority[si]
        cmp al,highestPriority
        jge skip_priority_update
    
        mov highestPriority,al
    
    skip_priority_update:
        inc si
        mov ax,si
        cmp al,processcount
        jl stats_loop
    
        printn ""
    
        lea dx,totalprocessmsg
        mov ah,09h
        int 21h
    
        mov dl,processcount
        add dl,30h
        mov ah,02h
        int 21h
    
        lea dx,totalmemorymsg
        mov ah,09h
        int 21h
    
        mov al,totalMemory
        mov ah,0
        mov bl,10
        div bl
    
        mov bh,ah
    
        cmp al,0
        je stats_print_memory_ones
    
        mov dl,al
        add dl,30h
        mov ah,02h
        int 21h
    
        mov dl,bh
        add dl,30h
        mov ah,02h
        int 21h
        jmp stats_avg_burst
    
    stats_print_memory_ones:
        mov dl,bh
        add dl,30h
        mov ah,02h
        int 21h
    
    stats_avg_burst:
        lea dx,avgburstmsg
        mov ah,09h
        int 21h
    
        mov al,totalBurst
        mov ah,0
        mov bl,processcount
        div bl
    
        mov avgBurst,al
    
        mov dl,avgBurst
        add dl,30h
        mov ah,02h
        int 21h
    
        lea dx,highestprioritymsg
        mov ah,09h
        int 21h
    
        mov dl,highestPriority
        add dl,30h
        mov ah,02h
        int 21h
    
        ret
    
stats_empty:
    printn ""
    printn "No Process Found"
    ret
        
        system_statistics endp           
     
     end main
    
    
           
    
    
      

     
