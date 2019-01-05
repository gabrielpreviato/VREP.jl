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

    matrix = Array{Cfloat, 1}(undef, 12)
    ret = ccall((:simxGetJointMatrix, "remoteApi.so"), Cint, (Cint, Cint, Ref{Cfloat}, Cint), clientID, jointHandle, matrix, operationMode)

    return ret, matrix
end

function simxSetSphericalJointMatrix(clientID::Cint, jointHandle::Cint, matrix::Array{Cfloat, 1}, operationMode::Cint)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    if (matrix.ndims == 1 && size(matrix, 1) == 12)
        return ccall((:simxSetSphericalJointMatrix, "remoteApi.so"), Cint, (Cint, Cint, Ref{Cfloat}, Cint), clientID, jointHandle, matrix, operationMode)
    else
        println("Passing Array with different size as expected (expected Array with size 12, received " + size(matrix, 1) + "). Matrix's values may be compromised")
        return ccall((:simxSetSphericalJointMatrix, "remoteApi.so"), Cint, (Cint, Cint, Ref{Cfloat}, Cint), clientID, jointHandle, matrix, operationMode)
        #throw(MethodError(""))
    end
end

function simxSetJointTargetVelocity(clientID::Cint, jointHandle::Cint, targetVelocity::Cfloat, operationMode::Cint)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    return ccall((:simxSetJointTargetVelocity, "remoteApi.so"), Cint, (Cint, Cint, Cfloat, Cint), clientID, jointHandle, targetVelocity, operationMode)
end

function simxSetJointTargetPosition(clientID, jointHandle, targetPosition::Cfloat, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    return ccall((:simxSetJointTargetPosition, "remoteApi.so"), Cint, (Cint, Cint, Cfloat, Cint), clientID, jointHandle, targetPosition, operationMode)
end

function simxJointGetForce(clientID, jointHandle, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#
    println("DEPRECATED. Use simxGetJointForce instead.")
    force = Cfloat
    return ccall((:simxGetJointForce, "remoteApi.so"), Cint, (Cint, Cint, Cfloat, Cint), clientID, jointHandle, force, operationMode), force
end

function simxGetJointForce(clientID, jointHandle, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#
    force = Cfloat
    return ccall((:simxGetJointForce, "remoteApi.so"), Cint, (Cint, Cint, Cfloat, Cint), clientID, jointHandle, force, operationMode), force
end
function simxSetJointForce(clientID, jointHandle, force::Cfloat, operationMode)

    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#
    return ccall((:simxSetJointForce, "remoteApi.so"), Cint, (Cint, Cint, Cfloat, Cint), clientID, jointHandle, force, operationMode)
end

function simxReadForceSensor(clientID, forceSensorHandle, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#
    state = Cuchar
    forceVector = Array{Cfloat, 1}(undef, 3)
    torqueVector = Array{Cfloat, 1}(undef, 3)
    ret = ccall((:simxReadForceSensor, "remoteApi.so"), Cint, (Cint, Cint, Cuchar, Ref{Cfloat}, Ref{Cfloat}, Cint), clientID, forceSensorHandle, state, forceVector, torqueVector, operationMode)
    return ret, state, forceVector, torqueVector
end

function simxBreakForceSensor(clientID, forceSensorHandle, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#
    return ccall((:simxBreakForceSensor, "remoteApi.so"), Cint, (Cint, Cint, Cint), clientID, forceSensorHandle, operationMode)
end

function simxReleaseBuffer(buffer)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    return ccall((:simxReleaseBuffer, "./remoteApi.so"), Cvoid, (Ptr{Cvoid},), buffer)
end

function simxReadVisionSensor(clientID, sensorHandle, operationMode)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    detectionState = Ref{Cuchar}()
    auxValues = Ref{Ptr{Cfloat}}()
    auxValuesCount = Ref{Ptr{Cint}}()

    ret = ccall((:simxReadVisionSensor, "./remoteApi.so"), Cint, (Cint, Cint, Ref{Cuchar}, Ptr{Ptr{Cfloat}}, Ptr{Ptr{Cint}}, Cint), clientID, sensorHandle, detectionState, auxValues, auxValuesCount, operationMode)

    auxValues2 = Array{Array{Float32, 1}, 1}()

    if ret == 0 && detectionState != 0
        if auxValuesCount[] != C_NULL && auxValuesCount[] != 0
            wrapped_auxValuesCount_size = unsafe_load(auxValuesCount[], 1)
            wrapped_auxValuesCount = unsafe_wrap(Array, auxValuesCount[], 1 + wrapped_auxValuesCount_size)[2:end]

            wrapped_auxValues = unsafe_wrap(Array, auxValues[], sum(wrapped_auxValuesCount))

            s = 1
            for i in wrapped_auxValuesCount
                push!(auxValues2, wrapped_auxValues[s:s + i - 1])
                s += i
            end
        end

        #free C buffers
        simxReleaseBuffer(auxValues[])
        simxReleaseBuffer(auxValuesCount[])
    end

    return ret, Bool(detectionState != 0), auxValues2
end

function simxStart(connectionAddress, connectionPort, waitUntilConnected, doNotReconnectOnceDisconnected, timeOutInMs, commThreadCycleInMs)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    ret = ccall((:simxStart, "./remoteApi.so"), Cint, (Cstring, Cint, Cuchar, Cuchar, Cint, Cint), connectionAddress, connectionPort, waitUntilConnected, doNotReconnectOnceDisconnected, timeOutInMs, commThreadCycleInMs)
    return ret
end

function simxFinish(clientID)
    #=
    Please have a look at the function description/documentation in the V-REP user manual
    =#

    return ccall((:simxFinish, "./remoteApi.so"), Cvoid, (Cint,), clientID)
end
