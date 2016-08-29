#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Environment
MKDIR=mkdir
CP=cp
GREP=grep
NM=nm
CCADMIN=CCadmin
RANLIB=ranlib
CC=gcc
CCC=g++
CXX=g++
FC=gfortran
AS=as

# Macros
CND_PLATFORM=MinGW-Windows
CND_DLIB_EXT=dll
CND_CONF=Release
CND_DISTDIR=dist
CND_BUILDDIR=build

# Include project Makefile
include Makefile

# Object Directory
OBJECTDIR=${CND_BUILDDIR}/${CND_CONF}/${CND_PLATFORM}

# Object Files
OBJECTFILES= \
	${OBJECTDIR}/app.o \
	${OBJECTDIR}/app/appView.o \
	${OBJECTDIR}/app/mdlLogger.o \
	${OBJECTDIR}/app/mdlUtil.o \
	${OBJECTDIR}/arrowBuilder.o \
	${OBJECTDIR}/cmd.o \
	${OBJECTDIR}/core/mdlElement.o \
	${OBJECTDIR}/core/mdlFence.o \
	${OBJECTDIR}/core/mdlGeom.o \
	${OBJECTDIR}/core/mdlLine.o \
	${OBJECTDIR}/core/mdlScan.o \
	${OBJECTDIR}/core/mdlSelect.o \
	${OBJECTDIR}/core/mdlText.o \
	${OBJECTDIR}/fenceReader.o \
	${OBJECTDIR}/main.o \
	${OBJECTDIR}/photoReader.o \
	${OBJECTDIR}/ui-cmd.o \
	${OBJECTDIR}/ui.o


# C Compiler Flags
CFLAGS=

# CC Compiler Flags
CCFLAGS=
CXXFLAGS=

# Fortran Compiler Flags
FFLAGS=

# Assembler Flags
ASFLAGS=

# Link Libraries and Options
LDLIBSOPTIONS=

# Build Targets
.build-conf: ${BUILD_SUBPROJECTS}
	"${MAKE}"  -f nbproject/Makefile-${CND_CONF}.mk ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/photoarrow.exe

${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/photoarrow.exe: ${OBJECTFILES}
	${MKDIR} -p ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}
	${LINK.c} -o ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/photoarrow ${OBJECTFILES} ${LDLIBSOPTIONS}

${OBJECTDIR}/app.o: app.mc 
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/app.o app.mc

${OBJECTDIR}/app/appView.o: app/appView.mc 
	${MKDIR} -p ${OBJECTDIR}/app
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/app/appView.o app/appView.mc

${OBJECTDIR}/app/mdlLogger.o: app/mdlLogger.mc 
	${MKDIR} -p ${OBJECTDIR}/app
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/app/mdlLogger.o app/mdlLogger.mc

${OBJECTDIR}/app/mdlUtil.o: app/mdlUtil.mc 
	${MKDIR} -p ${OBJECTDIR}/app
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/app/mdlUtil.o app/mdlUtil.mc

${OBJECTDIR}/arrowBuilder.o: arrowBuilder.mc 
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/arrowBuilder.o arrowBuilder.mc

${OBJECTDIR}/cmd.o: cmd.mc 
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/cmd.o cmd.mc

${OBJECTDIR}/core/mdlElement.o: core/mdlElement.mc 
	${MKDIR} -p ${OBJECTDIR}/core
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/core/mdlElement.o core/mdlElement.mc

${OBJECTDIR}/core/mdlFence.o: core/mdlFence.mc 
	${MKDIR} -p ${OBJECTDIR}/core
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/core/mdlFence.o core/mdlFence.mc

${OBJECTDIR}/core/mdlGeom.o: core/mdlGeom.mc 
	${MKDIR} -p ${OBJECTDIR}/core
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/core/mdlGeom.o core/mdlGeom.mc

${OBJECTDIR}/core/mdlLine.o: core/mdlLine.mc 
	${MKDIR} -p ${OBJECTDIR}/core
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/core/mdlLine.o core/mdlLine.mc

${OBJECTDIR}/core/mdlScan.o: core/mdlScan.mc 
	${MKDIR} -p ${OBJECTDIR}/core
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/core/mdlScan.o core/mdlScan.mc

${OBJECTDIR}/core/mdlSelect.o: core/mdlSelect.mc 
	${MKDIR} -p ${OBJECTDIR}/core
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/core/mdlSelect.o core/mdlSelect.mc

${OBJECTDIR}/core/mdlText.o: core/mdlText.mc 
	${MKDIR} -p ${OBJECTDIR}/core
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/core/mdlText.o core/mdlText.mc

${OBJECTDIR}/fenceReader.o: fenceReader.mc 
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/fenceReader.o fenceReader.mc

${OBJECTDIR}/main.o: main.mc 
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/main.o main.mc

${OBJECTDIR}/photoReader.o: photoReader.mc 
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/photoReader.o photoReader.mc

${OBJECTDIR}/ui-cmd.o: ui-cmd.mc 
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/ui-cmd.o ui-cmd.mc

${OBJECTDIR}/ui.o: ui.mc 
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.c) -O2 -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/ui.o ui.mc

# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${CND_BUILDDIR}/${CND_CONF}
	${RM} ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/photoarrow.exe

# Subprojects
.clean-subprojects:

# Enable dependency checking
.dep.inc: .depcheck-impl

include .dep.inc
