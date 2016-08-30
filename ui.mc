#include "ui.h"
#include "cmd.h"

DialogBox* getMainDialog() {
    return mdlDialog_find(C_ID_DLG_Main, NULL);
}

Private void mainHook(DialogMessage *dmP) {
    if (dmP->dialogId != C_ID_DLG_Main) return; // ignore any messages being sent to modal dialog hook
    dmP->msgUnderstood = TRUE;
    switch (dmP->messageType) {
        case DIALOG_MESSAGE_CREATE:
            break;
        case DIALOG_MESSAGE_DESTROY:
            mdlDialog_cmdNumberQueue(FALSE, CMD_MDL_UNLOAD, mdlSystem_getCurrTaskID(), TRUE);
            break;
        default:
            dmP->msgUnderstood = FALSE;
            break;
    }
}

Private void exitHook(DialogItemMessage *dimP) {
    dimP->msgUnderstood = TRUE;
    switch (dimP->messageType) {
        case DITEM_MESSAGE_BUTTON:
            if (dimP->u.button.buttonTrans != BUTTONTRANS_UP) break;
            mdlDialog_cmdNumberQueue(FALSE, CMD_MDL_UNLOAD, mdlSystem_getCurrTaskID(), TRUE);
            break;
        default:
            dimP->msgUnderstood = FALSE;
            break;
    }
}

Private void startHook(DialogItemMessage *dimP) {
    dimP->msgUnderstood = TRUE;
    switch (dimP->messageType) {
        case DITEM_MESSAGE_BUTTON:
            if (dimP->u.button.buttonTrans != BUTTONTRANS_UP) break;
            mdlLogger_info("photoarrow: START");
            command_loadFence();
            mdlLogger_info("photoarrow: END");
            break;
        default:
            dimP->msgUnderstood = FALSE;
            break;
    }
}

/* hooks array */
Private DialogHookInfo uHooks[] = {
    //Menu
    {C_HK_DLG_Main, mainHook},
    //File
    {C_HK_PDM_Start, startHook},
    {C_HK_PDM_Exit, exitHook},
};

int app_loadGui() {
    char *setP;
    RscFileHandle rscFileH;
    DialogBox *dbP;
    mdlResource_openFile(&rscFileH, NULL, 0);
    setP = mdlCExpression_initializeSet(VISIBILITY_DIALOG_BOX, 0, FALSE);
    //mdlDialog_publishComplexVariable (setP, "cfgStruct", "g_cfgStruct", &g_cfgStruct);
    mdlDialog_hookPublish(sizeof (uHooks) / sizeof (DialogHookInfo), uHooks);
    if ((dbP = mdlDialog_open(NULL, C_ID_DLG_Main)) == NULL) {
        mdlLogger_info("loadGui: window creation error");
        return FALSE;
    }
    return TRUE;
}

int app_loadCui() {
    if (mdlParse_loadCommandTable(NULL) == NULL) {
        mdlLogger_info("loadCui: command table is missing");
        return FALSE;
    }
    return TRUE;
}
