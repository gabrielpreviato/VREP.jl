function simxGetJointPosition(clientID, jointHandle, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#
    position = Ref{Cfloat}
    ret = ccall((:simxGetJointPosition, "remoteApi.so"), Cint, (Cint, Cint, Ref{Cfloat}, Cint), clientID, jointHandle, position, operationMode)

    return ret, position
end

function simxSetJointPosition(clientID, jointHandle, position, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    ret = ccall((:simxSetJointPosition, "remoteApi.so"), Cint, (Cint, Cint, Cfloat, Cint), clientID, jointHandle, position, operationMode)
    return ret
end

function simxGetJointMatrix(clientID, jointHandle, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    matrix = Array{Cfloat}(undef, 12)
    ret = ccall((:simxGetJointMatrix, "remoteApi.so"), Cint, (Cint, Cint, Ref{Cfloat}, Cint), clientID, jointHandle, matrix, operationMode))

    return ret, matrix


function simxSetSphericalJointMatrix(clientID::Cint, jointHandle::Cint, matrix::Array{Cfloat}, operationMode::Cint)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    if (matrix.ndims == 1 && size(matrix, 1) == 12):
        ret = ccall((:simxSetSphericalJointMatrix, "remoteApi.so"), Cint, (Cint, Cint, Ref{Cfloat}, Cint), clientID, jointHandle, matrix, operationMode))
        return ret
    else:
        #throw(MethodError(""))
    end
end

function simxSetJointTargetVelocity(clientID, jointHandle, targetVelocity, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    return c_SetJointTargetVelocity(clientID, jointHandle, targetVelocity, operationMode)
end

function simxSetJointTargetPosition(clientID, jointHandle, targetPosition, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    return c_SetJointTargetPosition(clientID, jointHandle, targetPosition, operationMode)
end
