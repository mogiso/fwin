!------------------------------------------------------------------------------------------------!
!> Write SAC-formatted seismograms
!!
!! @copyright
!! Copyright (c) 2019 Takuto Maeda. All rights reserved. 
!!
!! @license 
!! This software is released under the MIT license. See LICENSE for details. !--
module m_wsac

  use iso_fortran_env, only: DP=>real64, SP=>real32, error_unit, input_unit

  implicit none
  private

  !! -- Public Procedures
  public :: sac__hdr     ! sac data type
  public :: sac__write   ! write sac datafile
  public :: sac__init    ! initialize sac data type
  public :: sac__whdr    ! read header

  !----------------------------------------------------------------------------------------------!
  !> Sac Header Type Definition
  !--
  type sac__hdr
     
     !!               var name          description                   record#
     real(DP)      :: delta           ! sampling interval             (001)
     real(DP)      :: depmin          ! minimum value                 (002)
     real(DP)      :: depmax          ! maximum value                 (003)
     real(DP)      :: scale           ! multiplying scale factor      (004)
     real(DP)      :: odelta          ! Observed increment            (005)
     real(DP)      :: b               ! begenning independent value   (006)
     real(DP)      :: e               ! ending independent value      (007)
     real(DP)      :: o               ! event origin time             (008)
     real(DP)      :: a               ! first arrival time            (009)
     real(DP)      :: t0              ! time picks                    (011)
     real(DP)      :: t1              ! time picks                    (012)
     real(DP)      :: t2              ! time picks                    (013)
     real(DP)      :: t3              ! time picks                    (014)
     real(DP)      :: t4              ! time picks                    (015)
     real(DP)      :: t5              ! time picks                    (016)
     real(DP)      :: t6              ! time picks                    (017)
     real(DP)      :: t7              ! time picks                    (018)
     real(DP)      :: t8              ! time picks                    (019)
     real(DP)      :: t9              ! time picks                    (020)
     real(DP)      :: f               ! fini or end of event time     (021)
     real(DP)      :: resp0           ! instrument response param.    (022)
     real(DP)      :: resp1           ! instrument response param.    (023)
     real(DP)      :: resp2           ! instrument response param.    (024)
     real(DP)      :: resp3           ! instrument response param.    (025)
     real(DP)      :: resp4           ! instrument response param.    (026)
     real(DP)      :: resp5           ! instrument response param.    (027)
     real(DP)      :: resp6           ! instrument response param.    (028)
     real(DP)      :: resp7           ! instrument response param.    (029)
     real(DP)      :: resp8           ! instrument response param.    (030)
     real(DP)      :: resp9           ! instrument response param.    (031)
     real(DP)      :: stla            ! station latitude              (032)
     real(DP)      :: stlo            ! station longitude             (033)
     real(DP)      :: stel            ! station elevation (m)         (034)
     real(DP)      :: stdp            ! station depth (m)             (035)
     real(DP)      :: evla            ! event latitude                (036)
     real(DP)      :: evlo            ! event longitude               (037)
     real(DP)      :: evel            ! event elevation (m)           (038)
     real(DP)      :: evdp            ! event depth (m)               (039)
     real(DP)      :: mag             ! event magnitude               (040)
     real(DP)      :: user0           ! user header                   (041)
     real(DP)      :: user1           ! user header                   (042)
     real(DP)      :: user2           ! user header                   (043)
     real(DP)      :: user3           ! user header                   (044)
     real(DP)      :: user4           ! user header                   (045)
     real(DP)      :: user5           ! user header                   (046)
     real(DP)      :: user6           ! user header                   (047)
     real(DP)      :: user7           ! user header                   (048)
     real(DP)      :: user8           ! user header                   (049)
     real(DP)      :: user9           ! user header                   (050)
     real(DP)      :: dist            ! distance (km)                 (051)
     real(DP)      :: az              ! azimuth (deg)                 (052)
     real(DP)      :: baz             ! back azimuth (deg)            (053)
     real(DP)      :: gcarc           ! angular distance (deg)        (054)
     real(DP)      :: depmen          ! mean value                    (057)
     real(DP)      :: cmpaz           ! component azimuth             (058)
     real(DP)      :: cmpinc          ! component incident angle      (059) 
     real(DP)      :: xminimum        ! minimum value of x (spec)     (060)    
     real(DP)      :: xmaximum        ! maximum value of x (spec)     (061)    
     real(DP)      :: yminimum        ! minimum value of y (spec)     (062)    
     real(DP)      :: ymaximum        ! maximum value of y (spec)     (063)    
     integer       :: nzyear          ! reference time, year          (071)
     integer       :: nzjday          ! reference time, julian day    (072)
     integer       :: nzhour          ! reference time, hour          (073)
     integer       :: nzmin           ! reference time, minute        (074)
     integer       :: nzsec           ! reference time, second        (075)
     integer       :: nzmsec          ! reference time, millisecond   (076)
     integer       :: nvhdr           ! header version                (077)
     integer       :: norid           ! origin ID (CSS3.0)            (078)
     integer       :: nevid           ! event ID (CSS3.0)             (079)
     integer       :: npts            ! number of data points         (080)
     integer       :: nwfid           ! waveform ID (CSS3.0)          (082)
     integer       :: nxsize          ! spectral length               (083)
     integer       :: nysize          ! spectral width                (084)
     integer       :: iftype          ! type of file                  (086)
     integer       :: idep            ! type of dependent var.        (087)
     integer       :: iztype          ! reference time equivallence   (088)
     integer       :: iinst           ! instrument type               (090)
     integer       :: istreg          ! station region                (091)
     integer       :: ievreg          ! event region                  (092)
     integer       :: ievtyp          ! event type                    (093)
     integer       :: iqual           ! data quality                  (094)
     integer       :: isynth          ! synthetic data flag real=49   (095)
     integer       :: imagtyp         ! magnitude type                (096)
     integer       :: imagsrc         ! source of magnitude info.     (097)
     logical       :: leven           ! is evenly spaced file         (106)
     logical       :: lpspol          ! is positive polarity          (107)
     logical       :: lovrok          ! is overwrite ok?              (108)
     logical       :: lcalda          ! is calc distance azimuth      (109)
     character(8)  :: kstnm           ! station name                  (111)
     character(16) :: kevnm           ! event name                    (113)
     character(8)  :: khole           ! hole name                     (117)
     character(8)  :: ko              ! origin time identification    (119)
     character(8)  :: ka              ! time pick name                (121)
     character(8)  :: kt0             ! time pick name                (123)
     character(8)  :: kt1             ! time pick name                (125)
     character(8)  :: kt2             ! time pick name                (127)
     character(8)  :: kt3             ! time pick name                (129)
     character(8)  :: kt4             ! time pick name                (131)
     character(8)  :: kt5             ! time pick name                (133)
     character(8)  :: kt6             ! time pick name                (135)
     character(8)  :: kt7             ! time pick name                (137)
     character(8)  :: kt8             ! time pick name                (139)
     character(8)  :: kt9             ! time pick name                (141)
     character(8)  :: kf              ! fini identification           (143)
     character(8)  :: kuser0          ! user area                     (145)
     character(8)  :: kuser1          ! user area                     (147)
     character(8)  :: kuser2          ! user area                     (149)
     character(8)  :: kcmpnm          ! component name                (151)
     character(8)  :: knetwk          ! network name                  (153)
     character(8)  :: kdatrd          ! date data onto comp.          (155)
     character(8)  :: kinst           ! instrument                    (157)

     !! Unofficial header at unused blocks
     real(DP) :: user10 ! user header (064)
     real(DP) :: user11 ! user header (065)
     real(DP) :: user12 ! user header (066)
     real(DP) :: user13 ! user header (067)
     real(DP) :: user14 ! user header (068)
     real(DP) :: user15 ! user header (069)
     real(DP) :: user16 ! user header (070)
     integer  :: iuser0 ! user header (098)
     integer  :: iuser1 ! user header (099)
     integer  :: iuser2 ! user header (100)
     integer  :: iuser3 ! user header (101)
     integer  :: iuser4 ! user header (102)
     integer  :: iuser5 ! user header (103)
     integer  :: iuser6 ! user header (104)
     integer  :: iuser7 ! user header (105)
     logical  :: luser0 ! user header (110)

     !! associated information from sac header
     integer :: nzmonth ! month of begin time from nzjday
     integer :: nzday   ! day   of begin time from nzjday
     
     integer :: tim     ! absolute begin time from 1970/1/1 0:0:0 in second
     
  end type sac__hdr
  !----------------------------------------------------------------------------------------------!  
  !----------------------------------------------------------------------------------------------
  !> Write SAC file
  !!
  !! @par Usage
  !! call sac__write( char filename, type__header, real data(:), logical sw )
  !! data can be single or double precisions
  !! if sw = true, the existing file is automatically replaced. 
  !--
  interface sac__write
     
     module procedure wsac_d, wsac_s
     
  end interface
  !----------------------------------------------------------------------------------------------

contains
  
  !----------------------------------------------------------------------------------------------
  !> Write SAC file
  !! --
  subroutine wsac_d( fn_sac, ss, dat, overwrite )

    character(*),   intent(in)           :: fn_sac
    type(sac__hdr), intent(in)           :: ss
    real(DP),       intent(in)           :: dat(:)
    logical,        intent(in), optional :: overwrite
    !--
    real(SP), allocatable :: fdat(:)
    !----
    
    allocate(fdat(1:ss%npts))
    fdat(1:ss%npts) = real(dat(1:ss%npts))

    if( present( overwrite) ) then
       call wsac_s( fn_sac, ss, fdat, overwrite) 
    else
       call wsac_s( fn_sac, ss, fdat )
    end if

    deallocate( fdat )
  end subroutine wsac_d
  !----------------------------------------------------------------------------------------------

  !----------------------------------------------------------------------------------------------
  !> Write SAC file
  subroutine wsac_s( fn_sac, ss, dat, overwrite )

    character(*),   intent(in)           :: fn_sac
    type(sac__hdr), intent(in)           :: ss
    real(SP),       intent(in)           :: dat(:)
    logical,        intent(in), optional :: overwrite
    !--
    logical        :: isexist
    integer        :: io
    character(1)   :: yn
    !----
    
    !! overwrite check
    inquire( file = fn_sac, exist=isexist )
    if( isexist ) then
      if( present( overwrite) ) then
        if( .not. overwrite ) then
          write(error_unit,*) 'wsac: file '//trim(fn_sac)//' exists.' 
          write(error_unit,*) 'wsac: could not overwrite the file.'
          write(error_unit,*) 'wsac: return without success'
          write(error_unit,*)
          return
        end if
      else
        write(error_unit,*) 'wsac: file '//trim(fn_sac)//' exists.' 
        write(error_unit,*) 'wsac: Overwrite ? (y/n)' 
        read(input_unit,'(A)') yn
        if( yn /= 'y' .and. yn /='Y' ) then
          write(error_unit,*) 'wsac: could not overwrite the file.'
          write(error_unit,*) 'wsac: return without success'
          write(error_unit,*)
          return
        end if
      end if
    end if

    open( newunit=io, file=trim(fn_sac), action='write', access='stream', form='unformatted')

    call sac__whdr(io, ss) 

    write( io ) dat(1:ss%npts)
    close( io )
    
  end subroutine wsac_s
  !----------------------------------------------------------------------------------------------

  !----------------------------------------------------------------------------------------------
  !> Write SAC data header from pre-opened file io
  !--
  subroutine sac__whdr(io, ss)

    integer,        intent(in) :: io
    type(sac__hdr), intent(in) :: ss
    !--
    real(SP)       :: fheader(70)
    integer        :: iheader(71:105)
    logical        :: lheader(106:110)
    character(4)   :: aheader(111:158)
    integer        :: i
    !----

    !! header initialize
    fheader(1:70) = -12345.0
    iheader(71:105) = -12345
    lheader(106:110) = .false. 
    do i=111, 157, 2
       aheader( i ) = '-123'
       aheader( i+1 ) = '45'
    end do


    ! Copy header data to temprary arrays
    fheader(  1) = real( int( ss % delta * 1d7 ) ) / 1e7
    fheader(  2) = real( ss % depmin   )
    fheader(  3) = real( ss % depmax   )
    fheader(  4) = real( ss % scale    )
    fheader(  5) = real( ss % odelta   )
    fheader(  6) = real( ss % b        )
    fheader(  7) = real( ss % e        )
    fheader(  8) = real( ss % o        )
    fheader(  9) = real( ss % a        )
    fheader( 11) = real( ss % t0       )
    fheader( 12) = real( ss % t1       )
    fheader( 13) = real( ss % t2       )
    fheader( 14) = real( ss % t3       )
    fheader( 15) = real( ss % t4       )
    fheader( 16) = real( ss % t5       )
    fheader( 17) = real( ss % t6       )
    fheader( 18) = real( ss % t7       )
    fheader( 19) = real( ss % t8       )
    fheader( 20) = real( ss % t9       )
    fheader( 21) = real( ss % f        )
    fheader( 22) = real( ss % resp0    )
    fheader( 23) = real( ss % resp1    )
    fheader( 24) = real( ss % resp2    )
    fheader( 25) = real( ss % resp3    )
    fheader( 26) = real( ss % resp4    )
    fheader( 27) = real( ss % resp5    )
    fheader( 28) = real( ss % resp6    )
    fheader( 29) = real( ss % resp7    )
    fheader( 30) = real( ss % resp8    )
    fheader( 31) = real( ss % resp9    )
    fheader( 32) = real( ss % stla     )
    fheader( 33) = real( ss % stlo     )
    fheader( 34) = real( ss % stel     )
    fheader( 35) = real( ss % stdp     )
    fheader( 36) = real( ss % evla     )
    fheader( 37) = real( ss % evlo     )
    fheader( 38) = real( ss % evel     )
    fheader( 39) = real( ss % evdp     )
    fheader( 40) = real( ss % mag      )
    fheader( 41) = real( ss % user0    )
    fheader( 42) = real( ss % user1    )
    fheader( 43) = real( ss % user2    )
    fheader( 44) = real( ss % user3    )
    fheader( 45) = real( ss % user4    )
    fheader( 46) = real( ss % user5    )
    fheader( 47) = real( ss % user6    )
    fheader( 48) = real( ss % user7    )
    fheader( 49) = real( ss % user8    )
    fheader( 50) = real( ss % user9    )
    fheader( 51) = real( ss % dist     )
    fheader( 52) = real( ss % az       )
    fheader( 53) = real( ss % baz      )
    fheader( 54) = real( ss % gcarc    )
    fheader( 57) = real( ss % depmen   )
    fheader( 58) = real( ss % cmpaz    )
    fheader( 59) = real( ss % cmpinc   )
    fheader( 60) = real( ss % xminimum )
    fheader( 61) = real( ss % xmaximum )
    fheader( 62) = real( ss % yminimum )
    fheader( 63) = real( ss % ymaximum )
    fheader( 64) = real( ss % user10   )
    fheader( 65) = real( ss % user11   )
    fheader( 66) = real( ss % user12   )
    fheader( 67) = real( ss % user13   )
    fheader( 68) = real( ss % user14   )
    fheader( 69) = real( ss % user15   )
    fheader( 70) = real( ss % user16   )
    
    iheader( 71) = ss % nzyear
    iheader( 72) = ss % nzjday
    iheader( 73) = ss % nzhour
    iheader( 74) = ss % nzmin
    iheader( 75) = ss % nzsec
    iheader( 76) = ss % nzmsec
    iheader( 77) = ss % nvhdr
    iheader( 78) = ss % norid
    iheader( 79) = ss % nevid
    iheader( 80) = ss % npts
    iheader( 82) = ss % nwfid
    iheader( 83) = ss % nxsize
    iheader( 84) = ss % nysize
    iheader( 86) = ss % iftype
    iheader( 87) = ss % idep
    iheader( 88) = ss % iztype
    iheader( 90) = ss % iinst
    iheader( 91) = ss % istreg
    iheader( 92) = ss % ievreg
    iheader( 93) = ss % ievtyp
    iheader( 94) = ss % iqual
    iheader( 95) = ss % isynth
    iheader( 96) = ss % imagtyp
    iheader( 97) = ss % imagsrc

    iheader( 98) = ss % iuser0
    iheader( 99) = ss % iuser1
    iheader(100) = ss % iuser2
    iheader(101) = ss % iuser3
    iheader(102) = ss % iuser4
    iheader(103) = ss % iuser5
    iheader(104) = ss % iuser6
    iheader(105) = ss % iuser7
    
    lheader(106) = ss % leven
    lheader(107) = ss % lpspol
    lheader(108) = ss % lovrok
    lheader(109) = ss % lcalda
    
    lheader(110) = ss % luser0

    aheader(111) = ss%kstnm(1:4);  aheader(112) = ss%kstnm(5:8)
    aheader(113) = ss%kevnm(1:4);  aheader(114) = ss%kevnm(5:8)
    aheader(115) = ss%kevnm(9:12); aheader(116) = ss%kevnm(13:16)
    aheader(117) = ss%khole(1:4);  aheader(118) = ss%khole(5:8)
    aheader(119) = ss%ko(1:4);     aheader(120) = ss%ko(5:8)
    aheader(121) = ss%ka(1:4);     aheader(122) = ss%ka(5:8)
    aheader(123) = ss%kt0(1:4);    aheader(124) = ss%kt0(5:8)
    aheader(125) = ss%kt1(1:4);    aheader(126) = ss%kt1(5:8)
    aheader(127) = ss%kt2(1:4);    aheader(128) = ss%kt2(5:8)
    aheader(129) = ss%kt3(1:4);    aheader(130) = ss%kt3(5:8)
    aheader(131) = ss%kt4(1:4);    aheader(132) = ss%kt4(5:8)
    aheader(133) = ss%kt5(1:4);    aheader(134) = ss%kt5(5:8)
    aheader(135) = ss%kt6(1:4);    aheader(136) = ss%kt6(5:8)
    aheader(137) = ss%kt7(1:4);    aheader(138) = ss%kt7(5:8)
    aheader(139) = ss%kt8(1:4);    aheader(140) = ss%kt8(5:8)
    aheader(141) = ss%kt9(1:4);    aheader(142) = ss%kt9(5:8)
    aheader(143) = ss%kf(1:4);     aheader(143) = ss%kf(5:8)
    aheader(145) = ss%kuser0(1:4); aheader(146) = ss%kuser0(5:8)
    aheader(147) = ss%kuser1(1:4); aheader(148) = ss%kuser1(5:8)
    aheader(149) = ss%kuser2(1:4); aheader(150) = ss%kuser2(5:8)
    aheader(151) = ss%kcmpnm(1:4); aheader(152) = ss%kcmpnm(5:8)
    aheader(153) = ss%knetwk(1:4); aheader(154) = ss%knetwk(5:8)
    aheader(155) = ss%kdatrd(1:4); aheader(156) = ss%kdatrd(5:8)
    aheader(157) = ss%kinst(1:4);  aheader(158) = ss%kinst(5:8)

    !! write
    write( io ) fheader(1:70)
    write( io ) iheader(71:105)
    write( io ) lheader(106:110)
    write( io ) aheader(111:158)
    
  end subroutine sac__whdr
  !----------------------------------------------------------------------------------------------

  !----------------------------------------------------------------------------------------------
  !> Initialize SAC header
  subroutine sac__init( ss )

    type(sac__hdr), intent(inout) :: ss
    !--
    real(SP)     :: ferr = -12345.0_SP
    integer      :: ierr = -12345
    character(6) :: cerr = '-12345'
    !----
    
    ss%delta    = ferr
    ss%depmin   = ferr
    ss%depmax   = ferr
    ss%scale    = ferr
    ss%odelta   = ferr
    ss%b        = ferr
    ss%e        = ferr
    ss%o        = ferr
    ss%a        = ferr
    ss%t0       = ferr
    ss%t1       = ferr
    ss%t2       = ferr
    ss%t3       = ferr
    ss%t4       = ferr
    ss%t5       = ferr
    ss%t6       = ferr
    ss%t7       = ferr
    ss%t8       = ferr
    ss%t9       = ferr
    ss%f        = ferr
    ss%resp0    = ferr
    ss%resp1    = ferr
    ss%resp2    = ferr
    ss%resp3    = ferr
    ss%resp4    = ferr
    ss%resp5    = ferr
    ss%resp6    = ferr
    ss%resp7    = ferr
    ss%resp8    = ferr
    ss%resp9    = ferr
    ss%stla     = ferr
    ss%stlo     = ferr
    ss%stel     = ferr
    ss%stdp     = ferr
    ss%evla     = ferr
    ss%evlo     = ferr
    ss%evel     = ferr
    ss%evdp     = ferr
    ss%mag      = ferr
    ss%user0    = ferr
    ss%user1    = ferr
    ss%user2    = ferr
    ss%user3    = ferr
    ss%user4    = ferr
    ss%user5    = ferr
    ss%user6    = ferr
    ss%user7    = ferr
    ss%user8    = ferr
    ss%user9    = ferr
    ss%dist     = ferr
    ss%az       = ferr
    ss%baz      = ferr
    ss%gcarc    = ferr
    ss%depmen   = ferr
    ss%cmpaz    = ferr
    ss%cmpinc   = ferr
    ss%xminimum = ferr
    ss%xmaximum = ferr
    ss%yminimum = ferr
    ss%ymaximum = ferr
    ss%nzyear   = ierr
    ss%nzjday   = ierr
    ss%nzhour   = ierr
    ss%nzmin    = ierr
    ss%nzsec    = ierr
    ss%nzmsec   = ierr
    ss%nvhdr    = 6 ! header version
    ss%norid    = ierr
    ss%nevid    = ierr
    ss%npts     = ierr
    ss%nwfid    = ierr
    ss%nxsize   = ierr
    ss%nysize   = ierr
    ss%iftype   = 1 ! time series file
    ss%idep     = ierr
    ss%iztype   = ierr
    ss%iinst    = ierr
    ss%istreg   = ierr
    ss%ievreg   = ierr
    ss%ievtyp   = ierr
    ss%iqual    = ierr
    ss%isynth   = ierr
    ss%imagtyp  = ierr
    ss%imagsrc  = ierr
    ss%leven    = .true.
    ss%lpspol   = .false.
    ss%lovrok   = .true.
    ss%lcalda   = .true.
    ss%kstnm    = cerr
    ss%kcmpnm   = cerr
    ss%kevnm    = cerr
    ss%khole    = cerr
    ss%ko       = cerr
    ss%ka       = cerr
    ss%kt0      = cerr
    ss%kt1      = cerr
    ss%kt2      = cerr
    ss%kt3      = cerr
    ss%kt4      = cerr
    ss%kt5      = cerr
    ss%kt6      = cerr
    ss%kt7      = cerr
    ss%kt8      = cerr
    ss%kt9      = cerr
    ss%kf       = cerr
    ss%kuser0   = cerr
    ss%kuser1   = cerr
    ss%kuser2   = cerr
    ss%knetwk   = cerr
    ss%kdatrd   = cerr
    ss%kinst    = cerr
    
    !! unoficial headers
    ss%user10   = ferr
    ss%user11   = ferr
    ss%user12   = ferr
    ss%user13   = ferr
    ss%user14   = ferr
    ss%user15   = ferr
    ss%user16   = ferr
    ss%iuser0   = ierr
    ss%iuser1   = ierr
    ss%iuser2   = ierr
    ss%iuser3   = ierr
    ss%iuser4   = ierr
    ss%iuser5   = ierr
    ss%iuser6   = ierr
    ss%iuser7   = ierr
    ss%luser0   = .false.

    !! fortran-only headers
    ss%nzmonth  = ierr
    ss%nzday    = ierr
    ss%tim      = ierr

  end subroutine sac__init
  !----------------------------------------------------------------------------------------------
  
end module m_wsac
!------------------------------------------------------------------------------------------------
