#!/usr/local/bin/zsh

function dbgmsg() {
	echo "${1}" >&2
}


function sanitize_the_things() {
	if [ -z "${zvol}" ]; then
		dbgmsg "[-] Set zvol, you idiot"
		return 1
	fi

	if [ ! -e "/dev/zvol/${zvol}" ]; then
		dbgmsg "[-] ${zvol} doesn't exist, you dinosaur"
		return 1
	fi

	if [ -z "${name}" ]; then
		dbgmsg "[-] Set name, you nincompoop"
		return 1
	fi

	if [ -z "${port}" ]; then
		dbgmsg "[-] Set port, you irresponsible noob"
		return 1
	fi

	if [ -z "${tap}" ]; then
		dbgmsg "[-] Set tap, you cancerous infection"
		return 1
	fi

	if [ ! -z "${iso}" ]; then
		if [ ! -f "${iso}" ]; then
			dbgmsg "[-] ${iso} doesn't exist, you premature typist"
			return 1
		fi
		iso="-s 3,ahci-cd,${iso}"
	fi

	if [ -z "${cpu}" ]; then
		cpu=4
	fi

	if [ -z "${mem}" ]; then
		mem="2G"
	fi

	if [ -z "${size}" ]; then
		size="w=1024,h=768"
	fi

	if [ ! -z "${vncwait}" ]; then
		vncwait=",wait"
	else
		vncwait=""
	fi

	if [ ! -z "${tablet}" ]; then
		tablet="-s 30,xhci,tablet"
	fi
}

function do_the_thing() {
	local res

	sanitize_the_things
	if [ ${?} -gt 0 ]; then
		return 1
	fi

	while true; do
		bhyve \
			-c ${cpu} \
			-m ${mem} \
			-w \
			-H \
			-s 0,hostbridge \
			${iso} \
			-s 4,ahci-hd,/dev/zvol/${zvol} \
			-s 5,virtio-net,${tap} \
			-l bootrom,/scratch/bhyve/BHYVE_UEFI_20160526.fd \
			-s 29,fbuf,tcp=127.0.0.1:${port},${size}${vncwait} \
			${tablet} \
			-s 31,lpc \
			-l com1,/dev/nmdm-${name}-A \
			${name}
		res=${?}

		if [ ${res} -ne 0 ]; then
			break
		fi
	done

	bhyvectl --destroy --vm=${name}
}
