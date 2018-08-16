function simxGetJointPosition(clientID, jointHandle, operationMode)
    '''
    Please have a look at the function description/documentation in the V-REP user manual
    '''
    position = Ref{Cfloat}
    ret = ccall((:simxGetJointPosition, "remoteApi.so"), Cint, (Cint, Cint, Ref{Cfloat}, Cint), clientID, jointHandle, position, operationMode)

    return ret, position
end
